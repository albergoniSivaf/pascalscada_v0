unit psbufdataset;

interface

uses
  DB, Classes{$IFDEF FPC}, BufDataset{$ELSE}, fpsbufdataset{$ENDIF};

type

  TFPSBufDataSet = class (TBufDataset)
  public
    Procedure CopyFromDataset(DataSet : TDataSet); {$IFNDEF FPC} overload; {$ENDIF}
    Procedure CopyFromDataset(DataSet : TDataSet; CopyData : Boolean); {$IFNDEF FPC} overload; {$ENDIF}
  end;

implementation

{ TFPSBufDataSet }

procedure TFPSBufDataSet.CopyFromDataset(DataSet: TDataSet);
begin
  CopyFromDataset(Dataset,True);
end;

procedure TFPSBufDataSet.CopyFromDataset(DataSet: TDataSet; CopyData: Boolean);
Var
  I  : Integer;
  F,F1,F2 : TField;
  L1,L2  : TList;
  N : String;

begin
  //Clear(True);
  // NOT from fielddefs. The data may not be available in buffers !!
  For I:=0 to Dataset.FieldCount-1 do
    begin
    F:=Dataset.Fields[I];
    TFieldDef.Create(FieldDefs,F.FieldName,F.DataType,F.Size,F.Required,F.FieldNo);
    end;
  CreateDataset;
  If CopyData then
    begin
    Open;
    L1:=TList.Create;
    Try
      L2:=TList.Create;
      Try
        For I:=0 to FieldDefs.Count-1 do
          begin
          N:=FieldDefs[I].Name;
          F1:=FieldByName(N);
          F2:=DataSet.FieldByName(N);
          L1.Add(F1);
          L2.Add(F2);
          end;
        Dataset.DisableControls;
        Try
          Dataset.Open;
          While not Dataset.EOF do
            begin
            Append;
            For I:=0 to L1.Count-1 do
              begin
              F1:=TField(L1[i]);
              F2:=TField(L2[I]);
              Case F1.DataType of
                ftString   : F1.AsString:=F2.AsString;
                ftBoolean  : F1.AsBoolean:=F2.AsBoolean;
                ftFloat    : F1.AsFloat:=F2.AsFloat;
                ftLargeInt : F1.AsInteger:=F2.AsInteger;
                ftSmallInt : F1.AsInteger:=F2.AsInteger;
                ftInteger  : F1.AsInteger:=F2.AsInteger;
                ftDate     : F1.AsDateTime:=F2.AsDateTime;
                ftTime     : F1.AsDateTime:=F2.AsDateTime;
                ftDateTime : F1.AsDateTime:=F2.AsDateTime;
              end;
              end;
            Try
              Post;
            except
              Cancel;
              Raise;
            end;
            Dataset.Next;
            end;
        Finally
          Dataset.EnableControls;
        end;
      finally
        L2.Free;
      end;
    finally
      l1.Free;
    end;
    end;
end;

end.
