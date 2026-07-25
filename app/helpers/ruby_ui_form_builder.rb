class RubyUiFormBuilder < ActionView::Helpers::FormBuilder
  def text_field(method, options = {})
    options[:class] = "flex h-9 w-full rounded-md border bg-background px-3 py-1 text-sm shadow-xs transition-[color,box-shadow] border-border ring-0 ring-ring/0 placeholder:text-muted-foreground disabled:cursor-not-allowed disabled:opacity-50 file:border-0 file:bg-transparent file:text-sm file:font-medium aria-disabled:cursor-not-allowed aria-disabled:opacity-50 aria-disabled:pointer-events-none focus-visible:outline-none focus-visible:ring-ring/50 focus-visible:ring-2 focus-visible:border-ring focus-visible:shadow-sm #{options[:class]}"
    super(method, options)
  end

  def email_field(method, options = {})
    options[:class] = "flex h-9 w-full rounded-md border bg-background px-3 py-1 text-sm shadow-xs transition-[color,box-shadow] border-border ring-0 ring-ring/0 placeholder:text-muted-foreground disabled:cursor-not-allowed disabled:opacity-50 file:border-0 file:bg-transparent file:text-sm file:font-medium aria-disabled:cursor-not-allowed aria-disabled:opacity-50 aria-disabled:pointer-events-none focus-visible:outline-none focus-visible:ring-ring/50 focus-visible:ring-2 focus-visible:border-ring focus-visible:shadow-sm #{options[:class]}"
    super(method, options)
  end

  def password_field(method, options = {})
    options[:class] = "flex h-9 w-full rounded-md border bg-background px-3 py-1 text-sm shadow-xs transition-[color,box-shadow] border-border ring-0 ring-ring/0 placeholder:text-muted-foreground disabled:cursor-not-allowed disabled:opacity-50 file:border-0 file:bg-transparent file:text-sm file:font-medium aria-disabled:cursor-not-allowed aria-disabled:opacity-50 aria-disabled:pointer-events-none focus-visible:outline-none focus-visible:ring-ring/50 focus-visible:ring-2 focus-visible:border-ring focus-visible:shadow-sm #{options[:class]}"
    super(method, options)
  end

  def number_field(method, options = {})
    options[:class] = "flex h-9 w-full rounded-md border bg-background px-3 py-1 text-sm shadow-xs transition-[color,box-shadow] border-border ring-0 ring-ring/0 placeholder:text-muted-foreground disabled:cursor-not-allowed disabled:opacity-50 file:border-0 file:bg-transparent file:text-sm file:font-medium aria-disabled:cursor-not-allowed aria-disabled:opacity-50 aria-disabled:pointer-events-none focus-visible:outline-none focus-visible:ring-ring/50 focus-visible:ring-2 focus-visible:border-ring focus-visible:shadow-sm #{options[:class]}"
    super(method, options)
  end

  def text_area(method, options = {})
    options[:class] = "flex w-full rounded-md border bg-background px-3 py-1 text-sm shadow-sm transition-colors border-border placeholder:text-muted-foreground disabled:cursor-not-allowed disabled:opacity-50 file:border-0 file:bg-transparent file:text-sm file:font-medium focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring aria-disabled:cursor-not-allowed aria-disabled:opacity-50 aria-disabled:pointer-events-none #{options[:class]}"
    super(method, options)
  end

  def label(method, options = {})
    options[:class] = "empty:hidden text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70 peer-aria-disabled:cursor-not-allowed peer-aria-disabled:opacity-70 peer-aria-disabled:pointer-events-none #{options[:class]}"
    super(method, options)
  end

  def file_field(method, options = {})
    options[:class] = "flex h-9 w-full rounded-md border bg-background px-3 py-1 text-sm shadow-xs transition-[color,box-shadow] border-border ring-0 ring-ring/0 placeholder:text-muted-foreground disabled:cursor-not-allowed disabled:opacity-50 file:border-0 file:bg-transparent file:text-sm file:font-medium aria-disabled:cursor-not-allowed aria-disabled:opacity-50 aria-disabled:pointer-events-none focus-visible:outline-none focus-visible:ring-ring/50 focus-visible:ring-2 focus-visible:border-ring focus-visible:shadow-sm pt-[7px] #{options[:class]}"
    super(method, options)
  end

  def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
    options[:class] = "peer h-4 w-4 shrink-0 rounded-sm border-input ring-offset-background accent-primary disabled:cursor-not-allowed disabled:opacity-50 checked:bg-primary dark:checked:bg-secondary checked:text-primary checked:border-primary aria-disabled:cursor-not-allowed aria-disabled:opacity-50 aria-disabled:pointer-events-none focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2"
    super(method, options, checked_value, unchecked_value)
  end

  def select(method, choices = nil, options = {}, html_options = {}, &block)
    html_options[:class] = "border-border bg-transparent text-sm w-full min-w-0 appearance-none rounded-md border py-1 pr-8 pl-2.5 shadow-xs transition-[color,box-shadow] outline-none select-none ring-0 ring-ring/0 placeholder:text-muted-foreground selection:bg-primary selection:text-primary-foreground focus-visible:outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-2 disabled:pointer-events-none disabled:cursor-not-allowed disabled:opacity-50 aria-invalid:ring-destructive/20 aria-invalid:border-destructive aria-invalid:ring-2 h-9 #{html_options[:class]}"
    super(method, choices, options, html_options, &block)
  end

  def submit(value = nil, options = {}, &block)
    options[:class] = "whitespace-nowrap inline-flex items-center justify-center rounded-md font-medium transition-colors disabled:pointer-events-none disabled:opacity-50 focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring aria-disabled:pointer-events-none aria-disabled:opacity-50 aria-disabled:cursor-not-allowed px-4 py-2 h-9 text-sm bg-primary text-primary-foreground shadow hover:bg-primary/90 #{options[:class]}"
    super(value, options, &block)
  end
end
