Attribute VB_Name = "Module1"
Sub TuflowDataCleaner()

'Tony Ridley, Mott MacDonald
'2022.02.09
'TuFlow CSV Data Cleaner
'Removes First Column, Changes 2nd Column From Seconds to Hours
'Finds linked data and sums, places results in CleanData sheet

'declare shit
Dim NumColumn As Integer
Dim NumRow As Integer
Dim HeaderVal1 As String
Dim HashPos1 As Integer
Dim HeaderVal2 As String
Dim HashPos2 As Integer
Dim BeforeHash As String
Dim AfterHash1 As String
Dim AfterHash2 As String
Dim DupCount As Integer
Dim TimeSeconds As Double
Dim TimeHours As Double
Dim NumUnique As Integer
Dim SheetCounter As Integer
Dim SumDupVal As Double
Dim CSVSheetName As String
Dim NewCSVSheetName As String

'turn shit off
Application.ScreenUpdating = False
Application.EnableEvents = False
Application.DisplayAlerts = False

'check if "CleanData" sheet exists.
For q = 1 To Worksheets.Count
If Worksheets(q).Name = "CleanData" Then
SheetCounter = SheetCounter + 1
End If
Next q

'insert new sheet if needed
If SheetCounter = 0 Then
Sheets.Add(After:=Sheet1).Name = "CleanData"
If ActiveSheet.Index = Worksheets.Count Then
    Worksheets(1).Activate
Else
    ActiveSheet.Next.Activate
End If
End If

'get sheet name
CSVSheetName = ActiveSheet.Name

'get number of rows and columns in main CSV
NumColumn = Cells(1, Columns.Count).End(xlToLeft).Column
NumRow = Cells(Rows.Count, 1).End(xlUp).Row
    
'change seconds to hours and move to new sheet
Sheets("CleanData").Cells(1, 1).Value = "Time (hrs)"
For x = 1 To NumRow - 1
    TimeSeconds = Cells(x + 1, 2).Value
    TimeHours = TimeSeconds / 60 / 60
    Sheets("CleanData").Cells(x + 1, 1).Value = TimeHours
    Sheets("CleanData").Cells(x + 1, 1).NumberFormat = "0.0000"
Next x

'iterate through rows
For u = 1 To NumRow - 1
NumUnique = 0

'iterate columns, find the string before and after the #
For A = 2 To NumColumn
    HeaderVal1 = Cells(1, A).Value
    HeaderVal2 = Cells(1, 1 + A).Value
    HashPos1 = InStr(1, HeaderVal1, "#", vbTextCompare)
    HashPos2 = InStr(1, HeaderVal2, "#", vbTextCompare)
        If HashPos1 > 0 Then
            BeforeHash = Mid(HeaderVal1, 1, HashPos1 - 1)
            AfterHash1 = Mid(HeaderVal1, HashPos1 + 1)
            AfterHash2 = Mid(HeaderVal2, HashPos2 + 1)
                If AfterHash2 > AfterHash1 Then
                    SumDupVal = SumDupVal + Cells(1 + u, A).Value
                    Else
                    SumDupVal = SumDupVal + Cells(1 + u, A).Value
                    NumUnique = NumUnique + 1
                    Sheets("CleanData").Cells(1, 1 + NumUnique).Value = BeforeHash
                    Sheets("CleanData").Cells(1 + u, 1 + NumUnique).Value = SumDupVal
                    SumDupVal = 0
                End If
        Else
        End If
Next A
Next u

'Want to rename sheet but can't
'NewCSVSheetName = CSVSheetName & "edit"
'Sheets("CleanData").Name = NewCSVSheetName


Sheets("CleanData").Rows("1:1").NumberFormat = "0.00"
'turn shit back on
Application.DisplayAlerts = True
Application.ScreenUpdating = True
Application.EnableEvents = True



End Sub
