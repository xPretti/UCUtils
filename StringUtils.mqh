#ifndef STRINGUTILS_INCLUDED
#define STRINGUTILS_INCLUDED

#include "MathUtils.mqh"
#include "PointerUtils.mqh"

class CStringUtils
{
  private:
    static int GetReplace(string sourceStr, string openVar, string closeVar, string& result, string toReplace, bool sideBySide);

  public:
    // Methods
    static bool Trim(string& ref);

    //- GET
    static bool IsEmpty(string& ref);
    static string GetNoComments(string ref);
    static string GetNoComment(string ref);
    static string GetNoCommentCompound(string ref);
    static int GetReplace(string& sourceStr, ushort find, short toReplace = -1);
    static int GetReplace(string sourceStr, string openVar, string closeVar, string& result, string toReplace = "");
    static uint GetLengthNoSpace(string ref);
    static string GetNoSpace(string ref);
    static int GetPosStartNoSpace(string sourceStr);
    static int GetPosEndNoSpace(string sourceStr);
    static int GetSplit(string sourceStr, string separator, string& result[], int limit = 0);
    static int GetSplit(string sourceStr, ushort separator, ushort separatorByPass, string& result[], int limit = 0);
    static int GetFind(string sourceStr, ushort searchValue, ushort separatorByPass, uint start_pos = 0);
    static int GetFindReverse(string sourceStr, string searchValue, uint start_pos = 0, int end_pos = -1);
    static string GetUntilString(string sourceStr, string stopValue, int startPos = 0);
    static bool GetBetween(string sourceStr, string startValue, string stopValue, string& result);
    static string GetBetween(string sourceStr, string startValue, string stopValue);
    static string GetDatetimeToString(datetime time, bool date, bool hour, bool second);
    static string GetDateToString(datetime time, bool withHours, bool withSeconds);
    static string GetHourToString(datetime time, bool withSeconds);
    static string GetSecondsToString(datetime time);
    static string GetInsert(string sourceStr, string insert, int& pos);
    static string GetErase(string sourceStr, int startPos, int endPos);
    static string GetConcatenate(string& values1[], string& values2[], string between = "", string separator = "", string quote = "");
    static string GetConcatenate(string& values[], string separator = "");
    static string GetTrim(string ref);
    static string GetTrim(string ref, uchar trimChar);
    static bool GetStartsWith(string ref, string compare);
    static int GetBreak(string source, uint length, string breakValue, string& result[]);
    static string GetSubstr(string source, int start, int end);
    static string GetTruncate(string source, uint length, bool putPoint = false);

    // FiX methods
    static string FixFileString(string sourceStr);
    static int FixFileNewLine(string& sourceStr);
};

/**
 * Verificações
 */
bool CStringUtils::IsEmpty(string& ref)
{
  return (GetLengthNoSpace(ref) == 0);
}

/**
 * Retorna a nova string sem comentário
 */
string CStringUtils::GetNoComments(string ref)
{
  string newString = GetNoComment(ref);
  newString        = GetNoCommentCompound(newString);
  return (newString);
}
string CStringUtils::GetNoComment(string ref)
{
  string newString = "";
  bool inString    = false;
  uint index       = 0;
  uint length      = ref.Length();
  while(index < length)
    {
      if(ref.GetChar(index) == '"')
        {
          inString = !inString;
        }
      else
        {
          if(!inString)
            {
              if(ref.GetChar(index) == '/')
                {
                  if(index + 1 < length)
                    {
                      if(ref.GetChar(index + 1) == '/')
                        {
                          int findPos = GetFind(ref, 10, -1, index + 2);
                          if(findPos == -1)
                            {
                              break;
                            }
                          else
                            {
                              newString += ShortToString(ref.GetChar(findPos));
                              index = findPos + 1;
                              continue;
                            }
                        }
                    }
                }
            }
        }
      newString += ShortToString(ref.GetChar(index));
      index++;
    }
  return (newString);
}
string CStringUtils::GetNoCommentCompound(string ref)
{
  string newString = "";
  bool inString    = false;
  bool inComment   = false;
  uint index       = 0;
  uint length      = ref.Length();
  while(index < length)
    {
      if(ref.GetChar(index) == '"' && !inComment)
        {
          inString = !inString;
        }
      else
        {
          if(!inString)
            {
              if(ref.GetChar(index) == '/')
                {
                  if(index + 1 < length)
                    {
                      if(ref.GetChar(index + 1) == '*')
                        {
                          inComment = true;
                          index += 2;
                          continue;
                        }
                    }
                }
              else if(inComment && ref.GetChar(index) == '*')
                {
                  if(index + 1 < length)
                    {
                      if(ref.GetChar(index + 1) == '/')
                        {
                          inComment = false;
                          index += 2;
                          continue;
                        }
                    }
                }
            }
        }
      if(!inComment)
        {
          newString += ShortToString(ref.GetChar(index));
        }
      index++;
    }
  return (newString);
}

/**
 * Troca o valor do tipo ushort para outro, caso o chart de replace for -1 então o valor será removido
 */
int CStringUtils::GetReplace(string& sourceStr, ushort find, short toReplace = -1)
{
  if(GetLengthNoSpace(sourceStr) > 0)
    {
      int n         = 0;
      string result = "";
      for(uint i = 0; i < sourceStr.Length(); i++)
        {
          if(sourceStr.GetChar(i) == find)
            {
              n++;
              if(toReplace == -1)
                {
                  continue;
                }
              sourceStr.SetChar(i, (ushort)toReplace);
            }
          result += ShortToString(sourceStr.GetChar(i));
        }
      sourceStr = result;
      return (n);
    }
  return (0);
}
/**
 * Troca o valor que estiver entre duas strings e retorna a quantidade de trocas
 */
int CStringUtils::GetReplace(string sourceStr, string openVar, string closeVar, string& result, string toReplace = "")
{
  return (GetReplace(sourceStr, openVar, closeVar, result, toReplace, false));
}

/**
 * Retorna a quantidade de letras sem espaços
 */
uint CStringUtils::GetLengthNoSpace(string ref)
{
  StringReplace(ref, " ", "");
  return (ref.Length());
}

/**
 * Retorna a string sem espaços
 */
string CStringUtils::GetNoSpace(string ref)
{
  StringReplace(ref, " ", "");
  return (ref);
}

/**
 * Procura e retorna a posição da primeira ou ultima letra ignorando os espaços
 */
int CStringUtils::GetPosStartNoSpace(string sourceStr)
{
  int pos = 0;
  if((pos = StringTrimLeft(sourceStr)) > 0)
    {
      return (pos);
    }
  return (0);
}
int CStringUtils::GetPosEndNoSpace(string sourceStr)
{
  int size = StringLen(sourceStr);
  int pos  = 0;
  if((pos = StringTrimRight(sourceStr)) > 0)
    {
      return (size - pos);
    }
  return (size - 1);
}

/**
 * Devide uma string usando uma string como separador
 */
int CStringUtils::GetSplit(string sourceStr, string separator, string& result[], int limit = 0)
{
  if(GetLengthNoSpace(sourceStr) > 0)
    {
      int n          = 0;
      int start_pos  = 0;
      int pos        = -1;
      string getText = "";
      while((pos = StringFind(sourceStr, separator, start_pos)) != -1)
        {
          getText = StringSubstr(sourceStr, start_pos, pos - start_pos);
          ArrayResize(result, ++n, StringLen(getText));
          result[n - 1] = getText;
          if(n == limit)
            {
              return (n);
            };
          start_pos = pos + StringLen(separator);
        }
      getText = start_pos < StringLen(sourceStr) ? StringSubstr(sourceStr, start_pos) : "";
      ArrayResize(result, ++n, StringLen(getText));
      result[n - 1] = getText;
      return (n);
    }
  ArrayFree(result);
  return (0);
}
/**
 * Devide uma string usando uma string como separador porém com separador para ignorar sequencia
 */
int CStringUtils::GetSplit(string sourceStr, ushort separator, ushort separatorByPass, string& result[], int limit = 0)
{
  if(GetLengthNoSpace(sourceStr) > 0)
    {
      int n          = 0;
      int start_pos  = 0;
      int pos        = -1;
      string getText = "";
      while((pos = GetFind(sourceStr, separator, separatorByPass, start_pos)) != -1)
        {
          getText = StringSubstr(sourceStr, start_pos, pos - start_pos);
          ArrayResize(result, ++n, StringLen(getText));
          result[n - 1] = getText;
          ::StringReplace(result[n - 1], ShortToString(separatorByPass), "");
          if(n == limit)
            {
              return (n);
            };
          start_pos = pos + 1;
        }
      getText = start_pos < StringLen(sourceStr) ? StringSubstr(sourceStr, start_pos) : "";
      ArrayResize(result, ++n, StringLen(getText));
      result[n - 1] = getText;
      return (n);
    }
  ArrayFree(result);
  return (0);
}

/**
 * Encontra um valor e retorna a posição de inicio
 */
int CStringUtils::GetFind(string sourceStr, ushort searchValue, ushort separatorByPass, uint start_pos = 0)
{
  if(GetLengthNoSpace(sourceStr) > 0)
    {
      bool toBypass    = false;
      bool bypassValue = false;
      for(uint i = start_pos; i < sourceStr.Length(); i++)
        {
          bypassValue = sourceStr.GetChar(i) == separatorByPass;
          toBypass    = (toBypass && bypassValue) || (!toBypass && !bypassValue) ? false : true;
          if(!toBypass)
            {
              if(sourceStr.GetChar(i) == searchValue)
                {
                  return ((int)i);
                }
            }
        }
    }
  return (-1);
}

/**
 * Sistema de procura invertido
 */
int CStringUtils::GetFindReverse(string sourceStr, string searchValue, uint start_pos = 0, int end_pos = -1)
{
  int getPos = -1;
  if(GetLengthNoSpace(sourceStr) > 0)
    {
      start_pos++;
      int index = int(sourceStr.Length() - start_pos);
      if(end_pos > (int)start_pos)
        {
          sourceStr = StringSubstr(sourceStr, 0, end_pos);
        }
      while(index >= 0 && (getPos = StringFind(sourceStr, searchValue, (uint)index)) == -1)
        {
          index--;
        }
    }
  return (getPos);
}

/**
 * Copia toda a string até certa string
 */
string CStringUtils::GetUntilString(string sourceStr, string stopValue, int startPos = 0)
{
  int pos = StringFind(sourceStr, stopValue, startPos);
  return (StringSubstr(sourceStr, startPos, pos - startPos));
}

/**
 * Copia toda a string entre duas strings
 */
bool CStringUtils::GetBetween(string sourceStr, string startValue, string stopValue, string& result)
{
  uint lastSize = sourceStr.Length();
  result        = GetBetween(sourceStr, startValue, stopValue);
  return (lastSize != result.Length());
}
string CStringUtils::GetBetween(string sourceStr, string startValue, string stopValue)
{
  if(GetLengthNoSpace(sourceStr) > 0)
    {
      stopValue         = stopValue == "" ? startValue : stopValue;
      int pos1          = StringFind(sourceStr, startValue);
      pos1              = pos1 == -1 ? 0 : pos1;
      int pos2          = StringFind(sourceStr, stopValue, pos1 + (int)startValue.Length());
      int copyPos1      = pos1;
      int copyPos2      = pos2;
      string checkEqual = StringSubstr(sourceStr, pos1, startValue.Length());
      if(checkEqual == startValue)
        {
          copyPos1 = int(pos1 + startValue.Length());
        }
      return (StringSubstr(sourceStr, copyPos1, copyPos2 - copyPos1));
    }
  return (sourceStr);
}

/**
 * Retorna uma datetime convertida para string
 */
string CStringUtils::GetDatetimeToString(datetime time, bool date, bool hour, bool second)
{
  if(!date)
    {
      return (hour ? GetHourToString(time, second) : GetSecondsToString(time));
    }
  return (GetDateToString(time, hour, second));
}
string CStringUtils::GetDateToString(datetime time, bool withHours, bool withSeconds)
{
  int flags = TIME_DATE;
  if(withHours && withSeconds)
    {
      flags = TIME_DATE | TIME_MINUTES | TIME_SECONDS;
    }
  else if(withHours && !withSeconds)
    {
      flags = TIME_DATE | TIME_MINUTES;
    }
  else if(!withHours && withSeconds)
    {
      flags = TIME_DATE | TIME_SECONDS;
    }
  return (TimeToString(time, flags));
}
string CStringUtils::GetHourToString(datetime time, bool withSeconds)
{
  int flags = withSeconds ? TIME_MINUTES | TIME_SECONDS : TIME_MINUTES;
  return (TimeToString(time, flags));
}
string CStringUtils::GetSecondsToString(datetime time)
{
  int flags = TIME_SECONDS;
  return (TimeToString(time, flags));
}

/**
 * Insere um texto na posição selecionada
 */
string CStringUtils::GetInsert(string sourceStr, string insert, int& pos)
{
  if(pos >= 0 || pos > StringLen(sourceStr))
    {
      int posRef    = pos;
      string result = StringFormat("%s%s", StringSubstr(sourceStr, 0, posRef), insert);
      pos           = StringLen(result) - 1;
      result += StringSubstr(sourceStr, posRef);
      ResetLastError();
      return (result);
    }
  return (sourceStr);
}
/**
 * Insere um texto na posição selecionada
 */
string CStringUtils::GetErase(string sourceStr, int startPos, int endPos)
{
  if(startPos >= 0 && startPos < StringLen(sourceStr))
    {
      string result = StringSubstr(sourceStr, 0, startPos);
      int diference = endPos - startPos;
      result += StringSubstr(sourceStr, startPos + diference);
      ResetLastError();
      return (result);
    }
  return (sourceStr);
}
/**
 * Métodos usados para corrigir strings pegas de arquivos
 */
string CStringUtils::FixFileString(string sourceStr)
{
  string result = sourceStr;
  StringReplace(result, ShortToString('\\') + ShortToString('"'), ShortToString('"'));
  GetReplace(result, 10);
  GetReplace(result, 13);
  FixFileNewLine(result);
  return (result);
}
int CStringUtils::FixFileNewLine(string& sourceStr)
{
  // string ref = sourceStr;
  // return (GetReplace(ref, "\\", "n", sourceStr, "\n", true));
  return (StringReplace(sourceStr, ShortToString('\\') + ShortToString('n'), "\n"));
}

/**
 * Mescla dois arrays de tipos
 */
string CStringUtils::GetConcatenate(string& values1[], string& values2[], string between = "", string separator = "",
                                    string quote = "") // 1. " valor = valor", 2. " valor = valor, ", 3. " valor = 'valor', "
{
  string result = "";
  //.
  string column         = "";
  string value          = "";
  string columnAndValue = "";
  string quoteValue     = quote + "%s" + quote;
  //.
  int size       = (int)values1.Size();
  int sizeValues = (int)values2.Size();
  for(int i = 0; i < size; i++)
    {
      column         = values1[i] + between;
      value          = i < sizeValues ? StringFormat(quoteValue, values2[i]) : StringFormat(quoteValue, "");
      columnAndValue = column + value;
      result         = i > 0 ? result + separator + columnAndValue : columnAndValue;
    }
  return (result);
}
string CStringUtils::GetConcatenate(string& values[], string separator = "")
{
  string result = "";
  //.
  string column = "";
  //.
  int size = (int)values.Size();
  for(int i = 0; i < size; i++)
    {
      column = values[i];
      result = i > 0 ? result + separator + column : column;
    }
  return (result);
}

/**
 * Remove caracteres do inicio e final
 */
bool CStringUtils::Trim(string& ref)
{
  bool total = StringTrimRight(ref);
  total      = MathMax(total, StringTrimLeft(ref));
  return (total);
}
string CStringUtils::GetTrim(string ref)
{
  StringTrimRight(ref);
  StringTrimLeft(ref);
  return (ref);
}

string CStringUtils::GetTrim(string ref, uchar trimChar)
{
  ref = GetTrim(ref);
  if(GetLengthNoSpace(ref) > 0)
    {
      int pos1 = GetPosStartNoSpace(ref);
      int pos2 = GetPosEndNoSpace(ref);
      pos1     = pos1 <= 0 ? 0 : pos1;
      pos2     = pos2 <= 0 ? (int)ref.Length() - 1 : pos2;
      if(pos1 >= 0)
        {
          if(ref[pos1] == trimChar)
            {
              pos1++;
            }
        }
      if(pos2 >= 0)
        {
          if(ref[pos2] == trimChar)
            {
              pos2--;
            }
        }
      return (GetSubstr(ref, pos1, pos2));
    }
  return ("");
}

/**
 * Retorna verdadeiro caso tenha o texto no método informado
 */
bool CStringUtils::GetStartsWith(string ref, string compare)
{
  uint comapreSize = compare.Length();
  uint refSize     = ref.Length();
  if(refSize >= comapreSize)
    {
      int pos = StringFind(ref, compare);
      return (pos == 0);
    }
  return (false);
}

/**
 * Retorna um array da quebra de um texto longo
 */
int CStringUtils::GetBreak(string source, uint length, string breakValue, string& result[])
{
  if(source.Length() > length)
    {
      double size  = (double)source.Length() / length;
      int max      = (int)source.Length() / (int)CMathUtils::GetRound(size);
      int start    = 0;
      int pos      = 0;
      int posRight = 0;
      string text  = "";
      bool inLoop  = true;
      while(inLoop)
        {
          text     = "";
          pos      = start + max;
          posRight = StringFind(source, breakValue, pos);
          if(posRight > 0)
            {
              text  = StringSubstr(source, start, posRight - start);
              start = posRight;
            }
          else
            {
              text   = StringSubstr(source, start);
              inLoop = false;
            }
          if(text.Length() > 0)
            {
              uint count = result.Size();
              ArrayResize(result, count + 1);
              result[count] = text;
            }
          else
            {
              break;
            }
        }
      return (ArraySize(result));
    }
  return (0);
}

/**
 * Método para extrair uma substring usando posição de inicio e final
 */
string CStringUtils::GetSubstr(string source, int start, int end)
{
  if(end != 0)
    {
      end = end > 0 ? MathMax(start, end) - start : -1;
      return (StringSubstr(source, start, end + 1));
    }
  return ("");
}

/**
 * Metodo para truncar uma string
 */
string CStringUtils::GetTruncate(string source, uint length, bool putPoint = false)
{
  if(source.Length() > length)
    {
      return (StringSubstr(source, 0, length) + (putPoint ? "..." : ""));
    }
  return (source);
}

/**
 * Métodos Privados
 */
int CStringUtils::GetReplace(string sourceStr, string openVar, string closeVar, string& result, string toReplace, bool sideBySide)
{
  result = sourceStr;
  if(GetLengthNoSpace(sourceStr) > 0)
    {
      string replacer = "";
      int n           = 0;
      int start_pos   = 0;
      int pos1        = -1;
      int pos2        = -1;
      int newPos2     = 0;
      while((pos1 = StringFind(sourceStr, openVar, start_pos)) != -1)
        {
          //
          pos2 = StringFind(sourceStr, closeVar, (pos1 + StringLen(openVar)));
          if((sideBySide && (pos2 - pos1) == 1) || !sideBySide)
            {
              n++;
              newPos2  = (pos2 + StringLen(closeVar)) - pos1;
              replacer = StringSubstr(sourceStr, pos1, newPos2);
              StringReplace(result, replacer, toReplace);
            }
          if(pos2 == -1)
            {
              return (n);
            }
          start_pos = pos2 + StringLen(closeVar);
        }
      return (n);
    }
  return (0);
}

#endif /* STRINGUTILS_INCLUDED */
