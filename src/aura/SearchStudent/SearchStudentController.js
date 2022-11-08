/**
 * Created by samsung on 2022-11-07.
 */

({
    init: function (component, event, helper) {
        helper.getAllData(component);
        component.set('v.columns', [
            {label: '번호', fieldName: 'rowNumber', type: 'text'},
            {label: '학생정보', fieldName: 'Id', type: 'text'},
            {label: '학년', fieldName: 'Grade', type: 'text'},
            {label: '반', fieldName: 'Class', type: 'text'},
            {label: '이름', fieldName: 'Name', type: 'text'}
        ]);
//        component.set('v.data',[{
//            Id:'아이디',
//            Grade__c:'학년',
//            ClassNumber__c:'반',
//            Name:'이름'
//        }]);
    },

    fnSearch: function(component, event, helper){
        console.log('테스트 리스트: 00');
        helper.getAllData(component);

        console.log('테스트 리스트: 01');
    }
});