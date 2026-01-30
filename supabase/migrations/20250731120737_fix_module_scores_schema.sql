-- Drop existing module_scores table if it exists (to fix schema conflicts)
DROP TABLE IF EXISTS public.module_scores CASCADE;

-- Drop the view if it exists
DROP VIEW IF EXISTS public.course_score_summary CASCADE;

-- Create table for module scores with correct schema
CREATE TABLE public.module_scores (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL,
  course_id TEXT NOT NULL, -- Using TEXT to be compatible with both UUID and string course IDs
  module_id INTEGER NOT NULL,
  lesson_id INTEGER NOT NULL,
  score INTEGER NOT NULL DEFAULT 0,
  total_points INTEGER NOT NULL DEFAULT 100,
  percentage DECIMAL(5,2) GENERATED ALWAYS AS (ROUND((score::DECIMAL / total_points::DECIMAL) * 100, 2)) STORED,
  grade CHAR(1) GENERATED ALWAYS AS (
    CASE 
      WHEN (score::DECIMAL / total_points::DECIMAL) * 100 >= 90 THEN 'A'
      WHEN (score::DECIMAL / total_points::DECIMAL) * 100 >= 80 THEN 'B'
      WHEN (score::DECIMAL / total_points::DECIMAL) * 100 >= 70 THEN 'C'
      WHEN (score::DECIMAL / total_points::DECIMAL) * 100 >= 60 THEN 'D'
      ELSE 'F'
    END
  ) STORED,
  completed_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  UNIQUE(user_id, course_id, module_id, lesson_id)
);

-- Enable Row Level Security
ALTER TABLE public.module_scores ENABLE ROW LEVEL SECURITY;

-- Create policies for module scores
CREATE POLICY "Users can view their own scores" 
ON public.module_scores 
FOR SELECT 
USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own scores" 
ON public.module_scores 
FOR INSERT 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own scores" 
ON public.module_scores 
FOR UPDATE 
USING (auth.uid() = user_id);

CREATE POLICY "Instructors can view scores for their courses" 
ON public.module_scores 
FOR SELECT 
USING (EXISTS (
  SELECT 1 FROM public.courses c 
  WHERE c.id::TEXT = module_scores.course_id 
  AND c.instructor_id = auth.uid()
));

-- Create trigger for automatic timestamp updates
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_module_scores_updated_at
BEFORE UPDATE ON public.module_scores
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- Create indexes for better performance
CREATE INDEX idx_module_scores_user_course ON public.module_scores(user_id, course_id);
CREATE INDEX idx_module_scores_course_module ON public.module_scores(course_id, module_id);

-- Create view for course summary statistics
CREATE OR REPLACE VIEW public.course_score_summary AS
SELECT 
  user_id,
  course_id,
  COUNT(*) as completed_modules,
  SUM(score) as total_score,
  SUM(total_points) as total_possible_points,
  ROUND(AVG(percentage), 2) as average_percentage,
  CASE 
    WHEN AVG(percentage) >= 90 THEN 'A'
    WHEN AVG(percentage) >= 80 THEN 'B'
    WHEN AVG(percentage) >= 70 THEN 'C'
    WHEN AVG(percentage) >= 60 THEN 'D'
    ELSE 'F'
  END as overall_grade
FROM public.module_scores
GROUP BY user_id, course_id;
