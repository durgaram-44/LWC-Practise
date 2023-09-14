trigger trig_Contact_webToContact on Contact (before insert) 
{
  final String errMsg = 'The email already exists on another Contact: ';
  Set< String > emailSet = new Set< String >();
  for( Contact c : Trigger.new ) {
  emailSet.add( c.Email );
}
  Map< String, Id > duplicateContactMap = new Map< String, Id >();

  for( Contact c : [select Id, Email from Contact where Email = :emailSet] )
    duplicateContactMap.put( c.Email, c.Id );

  for( Contact c : Trigger.new ){
    Id duplicateContactId = duplicateContactMap.get( c.Email );
    if( duplicateContactId != null )
      c.addError( errMsg + duplicateContactId );
  }
}