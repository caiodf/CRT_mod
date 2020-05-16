function csvmaker(A,B,filename)
  
  fid=fopen([filename,'.csv'],'w');
  
  titlestr=[];
  for i=1:length(A)
    titlestr=[titlestr,A{i},','];
  end
  
  
  fprintf(fid,'%s\n',titlestr);
  
  for i=1:size(B,1)
      linestr=[];
      for j=1:length(B(i,:))
        linestr=[linestr,num2str(B(i,j)),','];
      end
      
      fprintf(fid,'%s\n',linestr);
  end
  
  fclose(fid);
  
