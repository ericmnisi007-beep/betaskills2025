-- Create invoices table for admin invoice management
CREATE TABLE public.invoices (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  invoice_number text NOT NULL UNIQUE,
  amount numeric NOT NULL DEFAULT 500.00,
  currency text NOT NULL DEFAULT 'ZAR',
  description text NOT NULL DEFAULT 'Admin Fee',
  status text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'sent', 'paid', 'cancelled')),
  issued_date timestamp with time zone NOT NULL DEFAULT now(),
  due_date timestamp with time zone NOT NULL DEFAULT (now() + interval '30 days'),
  sent_date timestamp with time zone,
  paid_date timestamp with time zone,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  created_by uuid REFERENCES auth.users(id)
);

-- Enable RLS
ALTER TABLE public.invoices ENABLE ROW LEVEL SECURITY;

-- Create policies for invoices
CREATE POLICY "Admins can manage all invoices" 
ON public.invoices 
FOR ALL 
USING (
  EXISTS (
    SELECT 1 FROM public.profiles 
    WHERE profiles.id = auth.uid() 
    AND profiles.role = 'admin'
  )
);

CREATE POLICY "Users can view their own invoices" 
ON public.invoices 
FOR SELECT 
USING (auth.uid() = user_id);

-- Create function to generate invoice number
CREATE OR REPLACE FUNCTION public.generate_invoice_number()
RETURNS text
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  year_str text;
  sequence_num int;
  invoice_num text;
BEGIN
  -- Get current year
  year_str := EXTRACT(year FROM now())::text;
  
  -- Get next sequence number for this year
  SELECT COALESCE(MAX(
    CASE 
      WHEN invoice_number LIKE year_str || '-%' 
      THEN (split_part(invoice_number, '-', 2))::int 
      ELSE 0 
    END
  ), 0) + 1
  INTO sequence_num
  FROM public.invoices;
  
  -- Format: YYYY-0001
  invoice_num := year_str || '-' || LPAD(sequence_num::text, 4, '0');
  
  RETURN invoice_num;
END;
$$;

-- Create trigger for updating timestamps
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_invoices_updated_at
  BEFORE UPDATE ON public.invoices
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();