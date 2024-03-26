package com.activiti.web.listener;

import com.activiti.common.utils.spring.SpringUtils;
import com.activiti.system.domain.Leaveapply;
import com.activiti.system.mapper.LeaveapplyMapper;
import org.activiti.engine.delegate.DelegateExecution;
import org.activiti.engine.delegate.JavaDelegate;

import java.util.List;

public class DataImport implements JavaDelegate {

    @Override
    public void execute(DelegateExecution execution) {
        LeaveapplyMapper leaveapplyMapper = SpringUtils.getBean(LeaveapplyMapper.class);
        List<Leaveapply> applys = leaveapplyMapper.selectLeaveapplyList(new Leaveapply());
        for (Leaveapply apply : applys) {
            System.out.println("请假信息" + apply.toString());
        }
        try {
            Thread.sleep(10000000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
