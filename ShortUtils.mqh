#ifndef SHORTUTILS_INCLUDED
#define SHORTUTILS_INCLUDED

class CShortUtils
{
  public:
    static bool IsAlpha(ushort s);
    static bool IsDigit(ushort s);
    static bool IsDigitDecimal(ushort s);
    static bool IsSignal(ushort s);
    static bool IsAlnum(ushort s);
    static bool IsOperator(ushort s);
    static bool IsOperatorCalc(ushort s);
    static bool IsText(ushort s);
};

bool CShortUtils::IsAlpha(ushort s)
{
  return ((s >= 'a' && s <= 'z') || (s >= 'A' && s <= 'Z'));
}
bool CShortUtils::IsDigit(ushort s)
{
  return ((s >= '0' && s <= '9'));
}
bool CShortUtils::IsDigitDecimal(ushort s)
{
  return (IsDigit(s) || s == '.');
}
bool CShortUtils::IsSignal(ushort s)
{
  return (s == '-' || s == '+');
}
bool CShortUtils::IsAlnum(ushort s)
{
  return (IsAlpha(s) || IsDigitDecimal(s));
}
bool CShortUtils::IsOperator(ushort s)
{
  return (s == '>' || s == '<' || s == '=' || s == '!' || s == '|' || s == '/' || s == '+' || s == '-' || s == '*' || s == '%' || s == '?' || s == ':' || s == '&' || s == '(' || s == ')' ||
          s == ',' || s == '.');
}
bool CShortUtils::IsOperatorCalc(ushort s)
{
  return (s == '+' || s == '-' || s == '*' || s == '/' || s == '%');
}
bool CShortUtils::IsText(ushort s)
{
  return ((s >= ' ' && s <= '~') || (s > 127 && s < 255));
}


#endif /* SHORTUTILS_INCLUDED */
