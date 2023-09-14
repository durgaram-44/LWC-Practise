<aura:application extends="force:slds">
    <c:GenericTreeGrid ltngcurrentRecId="0015g00000b55eU"
                                     ltngSobjectName="Account"
                                     ltngParentFieldAPIName="ParentId"
                                     ltngColumnLabelList="['Name','Type','Industry','Account Owner']"
                                     ltngColumnAPINameList="['Name','Type','Industry','Owner.Name']"
                                     ltngHyperlinkColumn="Name"/>
     
        
            <c:GenericTreeGrid ltngcurrentRecId="5005g000008YvfV"
                                     ltngSobjectName="Case"
                                     ltngParentFieldAPIName="ParentId"
                                     ltngColumnLabelList="['CaseNumber','Subject','Status','Case Owner','Case Owner Email','Account Owner']"
                                     ltngColumnAPINameList="['CaseNumber','Subject','Status','Owner.Name','Owner.Email','Account.Owner.Name']"
                                     ltngHyperlinkColumn="CaseNumber"
                                     ltngHeaderValue="Case Hierarchy"/>
        

   
</aura:application>