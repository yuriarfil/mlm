Attribute VB_Name = "Module1"
Option Explicit
Dim i As Integer
Dim j As Integer
Dim kE As Integer
Dim Epoch As Long
Dim rng As Range
Dim wsGD As Worksheet
Dim wsTRNdata As Worksheet
Dim wsTSTdata As Worksheet
Dim wsRS As Worksheet
Dim lsT As Integer
Dim kA As Integer

Sub backPropagate()
Application.ScreenUpdating = False

'// without adam optimizer
'    Call cpyPstData(Range("tmse"), Range("rmse_start").End(xlDown).Offset(1, 0))
'    Call cpyPstData(Range("wf_i1w"), Range("wi_1o"))
'    Call cpyPstData(Range("wf_i2w"), Range("wi_2o"))
'    Call cpyPstData(Range("wf_i3w"), Range("wi_3o"))
'    Call cpyPstData(Range("wf_i4w"), Range("wi_4o"))
'    Call cpyPstData(Range("wf_i5w"), Range("wi_5o"))
'    Call cpyPstData(Range("wf_O1w"), Range("wo_1o"))
'    Call cpyPstData(Range("wf_O2w"), Range("wo_2o"))
'    Call cpyPstData(Range("wf_O3w"), Range("wo_3o"))

'// with adam optimizer
    Call cpyPstData(Range("wf_i1wA"), Range("wi_1o"))
    Call cpyPstData(Range("wf_i2wA"), Range("wi_2o"))
    Call cpyPstData(Range("wf_i3wA"), Range("wi_3o"))
    Call cpyPstData(Range("wf_i4wA"), Range("wi_4o"))
    Call cpyPstData(Range("wf_i5wA"), Range("wi_5o"))
    Call cpyPstData(Range("wf_O1wA"), Range("wo_1o"))
    Call cpyPstData(Range("wf_O2wA"), Range("wo_2o"))
    Call cpyPstData(Range("wf_O3wA"), Range("wo_3o"))
    
Application.ScreenUpdating = True
End Sub

Sub run()
Dim i As Integer
Dim inptBx As Variant
Application.ScreenUpdating = False

Set wsGD = ThisWorkbook.Worksheets("nn_backprop_gd")
inptBx = InputBox("Specify Number of Epoch!!!")
If inptBx = vbNullString Then
    MsgBox "aborted!"
    Exit Sub
End If
    
    For i = 1 To inptBx
        feedData
        Call cpyPstData(Range("sum_mse"), Range("rmse_start_2").End(xlDown).Offset(1, 0))
        Call backPropagate
        Call lastMoment
        wsGD.Range("Z8:BX1000000").ClearContents
    Next
    
Application.ScreenUpdating = True
End Sub

Sub transposeData(rowToCopy As Range, pasteTarget As Range)
    pasteTarget.Resize(rowToCopy.Columns.Count) = Application.WorksheetFunction.Transpose(rowToCopy.Value)
End Sub

Sub cpyPstData(rowToCopy As Range, pasteTarget As Range)
        pasteTarget.Value2 = rowToCopy.Value2
End Sub

Sub feedData()
Set wsGD = ThisWorkbook.Worksheets("nn_backprop_gd")
Set wsTRNdata = ThisWorkbook.Worksheets("trn_data")

j = wsTRNdata.Range("O2")
    lsT = wsTRNdata.Range("C" & j).End(xlDown).Row
    For i = j To lsT
        '// input
        Call transposeData(wsTRNdata.Range("C" & i & ":" & "I" & i), wsGD.Range("B4"))
        '// output
        Call transposeData(wsTRNdata.Range("K" & i & ":" & "M" & i), wsGD.Range("U7"))
        '// transfer derivative
        Call transferDrv
    Next
'//K-Fold Cross Validation   
Select Case lsT
    Case Is = 22
        wsTRNdata.Range("O2") = 25
    Case Is = 45
        wsTRNdata.Range("O2") = 48
    Case Is = 68
        wsTRNdata.Range("O2") = 71
    Case Is = 91
        wsTRNdata.Range("O2") = 94
    Case Is = 114
        wsTRNdata.Range("O2") = 117
    Case Is = 137
        wsTRNdata.Range("O2") = 140
    Case Is = 160
        wsTRNdata.Range("O2") = 163
    Case Is = 183
        wsTRNdata.Range("O2") = 186
    Case Is = 206
        wsTRNdata.Range("O2") = 2
End Select
End Sub

Sub transferDrv()
Application.ScreenUpdating = False

j = Range("wo_1oo").End(xlDown).Offset(1, 0).Row
    Call transposeData(Range("wo_1"), Range("Z" & j & ":" & "AD" & j))
    Call transposeData(Range("wo_2"), Range("AE" & j & ":" & "AI" & j))
    Call transposeData(Range("wo_3"), Range("AJ" & j & ":" & "AN" & j))
    Call transposeData(Range("wi_1"), Range("AO" & j & ":" & "AU" & j))
    Call transposeData(Range("wi_2"), Range("AV" & j & ":" & "BB" & j))
    Call transposeData(Range("wi_3"), Range("BC" & j & ":" & "BI" & j))
    Call transposeData(Range("wi_4"), Range("BJ" & j & ":" & "BP" & j))
    Call transposeData(Range("wi_5"), Range("BQ" & j & ":" & "BW" & j))
    Call cpyPstData(Range("tmse"), Range("BX" & j))
    
Application.ScreenUpdating = True
End Sub

Sub lastMoment()
    Call cpyPstData(Range("mvData"), Range("mvTarget"))
End Sub

Sub testModel()
Set wsGD = ThisWorkbook.Worksheets("nn_backprop_gd")
Set wsTSTdata = ThisWorkbook.Worksheets("tst_data")

    lsT = wsTSTdata.Range("C2").End(xlDown).Row
    For i = 2 To lsT
        '// input
        Call transposeData(wsTSTdata.Range("C" & i & ":" & "I" & i), wsGD.Range("B4"))
        '// output
        Call transposeData(wsTSTdata.Range("K" & i & ":" & "M" & i), wsGD.Range("U7"))
        '// transfer output to test data
        Call transposeData(wsGD.Range("S7:S9"), wsTSTdata.Range("O" & i & ":" & "Q" & i))
    Next
End Sub

Sub reseT()
Application.ScreenUpdating = False
Set wsTRNdata = ThisWorkbook.Worksheets("trn_data")

    Call cpyPstData(Range("wf_i1"), Range("wi_1o"))
    Call cpyPstData(Range("wf_i2"), Range("wi_2o"))
    Call cpyPstData(Range("wf_i3"), Range("wi_3o"))
    Call cpyPstData(Range("wf_i4"), Range("wi_4o"))
    Call cpyPstData(Range("wf_i5"), Range("wi_5o"))
    Call cpyPstData(Range("wf_O1"), Range("wo_1o"))
    Call cpyPstData(Range("wf_O2"), Range("wo_2o"))
    Call cpyPstData(Range("wf_O3"), Range("wo_3o"))
    Range("init_mom").Value2 = 0
    Range("D70:" & "D" & Range("D70").End(xlDown).Row).ClearContents
    
    wsTRNdata.Range("O2").Value = 2

Application.ScreenUpdating = True
End Sub
