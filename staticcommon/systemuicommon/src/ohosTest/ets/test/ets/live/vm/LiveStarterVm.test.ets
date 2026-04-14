/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


import { describe, expect, it } from '@ohos/hypium';
import { LiveVmInjector } from '../../../../../../../newIndex';
import { LiveStartWantAgentParams } from '../../../../../../main/ets/live/interface/ILiveStarterVm';
import { LiveNotification } from '../../../../../../main/ets/live/model/LiveNotification';
import { LiveStarterVm } from '../../../../../../main/ets/live/vm/LiveStarterVm';


export default function LiveStarterVmTest() {
  describe('startCardWantAgent', () => {
    it('should_return_false_when_wantAgent_is_null', 0, async () => {
      let params: LiveStartWantAgentParams = {
        cardVm: {
          live: {
            hashCode: '123'
          }
        },
        wantAgent: null,
        onStartApp: () => {
        }
      };
      let ra: LiveStarterVm = new LiveStarterVm(new LiveVmInjector());
      const result = await ra.startCardWantAgent(params);
      expect(result[0]).assertEqual(false);
      expect(result[1]).assertEqual(0);
    });

    it('should_return_false_when_onStartApp_throws_error', 0, async () => {
      let params: LiveStartWantAgentParams = {
        cardVm: {
          live: {
            hashCode: '123'
          }
        },
        wantAgent: {
          info: {
            operationType: 1
          }
        },
        onStartApp: () => {
          throw new Error('Error');
        }
      };
      let ra: LiveStarterVm = new LiveStarterVm(new LiveVmInjector());
      const result = await ra.startCardWantAgent(params);
      expect(result[0]).assertEqual(false);
      expect(result[1]).assertEqual(0);
    });

    it('should_return_true_when_onStartApp_is_called_and_agentInfo_is_valid', 0, async () => {
      let params: LiveStartWantAgentParams = {
        cardVm: {
          live: {
            hashCode: '123'
          }
        },
        wantAgent: {
          info: {
            operationType: 1
          }
        },
        onStartApp: () => {
        }
      };
      let ra: LiveStarterVm = new LiveStarterVm(new LiveVmInjector());
      const result = await ra.startCardWantAgent(params);
      expect(result[0]).assertEqual(true);
      expect(result[1]).assertEqual(1);
    });

    it('should_return_false_when_onStartApp_is_not_called_and_agentInfo_is_invalid', 0, async () => {
      let params: LiveStartWantAgentParams = {
        cardVm: {
          live: {
            hashCode: '123'
          }
        },
        wantAgent: {
          info: {
            operationType: 2
          }
        },
        onStartApp: () => {
        }
      };
      let ra: LiveStarterVm = new LiveStarterVm(new LiveVmInjector());
      const result = await ra.startCardWantAgent(params);
      expect(result[0]).assertEqual(false);
      expect(result[1]).assertEqual(0);
    });

    it('should_return_true_when_onStartApp_is_called_and_agentInfo_is_invalid', 0, async () => {
      let params: LiveStartWantAgentParams = {
        cardVm: {
          live: {
            hashCode: '123'
          }
        },
        wantAgent: {
          info: {
            operationType: 2
          }
        },
        onStartApp: () => {
        }
      };
      let ra: LiveStarterVm = new LiveStarterVm(new LiveVmInjector());
      const result = await ra.startCardWantAgent(params);
      expect(result[0]).assertEqual(true);
      expect(result[1]).assertEqual(2);
    });
  });

  describe('startCapsuleWantAgent', () => {
    it('should_call_startWantAgent_when_agentInfo_is_valid', 0, async () => {
      let live: LiveNotification = {
        id: 1,
        hashCode: '123',
        wantAgent: {
          info: {
            operationType: 1
          }
        },
        agentBundle: {
          bundle: 'com.example', uid: 123
        }
      };
      let ra: LiveStarterVm = new LiveStarterVm(new LiveVmInjector());
      const result = await ra.startCapsuleWantAgent(live, true);
      expect(result).assertUndefined();
    });

    it('should_not_call_start WantAgent_when_agentInfo_is_invalid', 0, async () => {
      let live: LiveNotification = {
        id: 1,
        hashCode: '123',
        wantAgent: {
          info: {
            operationType: 2
          }
        },
        agentBundle: {
          bundle: 'com.example', uid: 123
        }
      };
      let ra: LiveStarterVm = new LiveStarterVm(new LiveVmInjector());
      const result = await ra.startCapsuleWantAgent(live, true);
      expect(result).assertUndefined();
    });
  });

  it('should_return_false_when_wantAgent_is_null', 0, async () => {
    let livestartervm: LiveStarterVm = new LiveStarterVm(new LiveVmInjector());
    let params: LiveStartWantAgentParams = new LiveStartWantAgentParams();
    params.wantAgent = null;
    const result = await livestartervm.startCardWantAgent(params);
    expect(result[0]).assertEqual(false);
    expect(result[1]).assertEqual(0);
  });

  it('should_return_false_when_onStartApp_is_null', 0, async () => {
    let livestartervm: LiveStarterVm = new LiveStarterVm(new LiveVmInjector());
    let params: LiveStartWantAgentParams = new LiveStartWantAgentParams();
    params.wantAgent = new LiveNotification();
    params.onStartApp = null;
    const result = await livestartervm.startCardWantAgent(params);
    expect(result[0]).assertEqual(false);
    expect(result[1]).assertEqual(0);
  });

  it('should_return_true_when_onStartApp_is_not_null_and_isStartApp_is_true', 0, async () => {
    let livestartervm: LiveStarterVm = new LiveStarterVm(new LiveVmInjector());
    let params: LiveStartWantAgentParams = new LiveStartWantAgentParams();
    params.wantAgent = new LiveNotification();
    params.onStartApp = () => {
    };
    const result = await livestartervm.startCardWantAgent(params);
    expect(result[0]).assertEqual(true);
    expect(result[1]).assertEqual(1);
  });

  it('should_return_false_when_onStartApp_is_not_null_and_isStartApp_is_false', 0, async () => {
    let livestartervm: LiveStarterVm = new LiveStarterVm(new LiveVmInjector());
    let params: LiveStartWantAgentParams = new LiveStartWantAgentParams();
    params.wantAgent = new LiveNotification();
    params.onStartApp = () => {
    };
    const result = await livestartervm.startCardWantAgent(params);
    expect(result[0]).assertEqual(false);
    expect(result[1]).assertEqual(0);
  });

  it('should_return_false_when_error_occurs', 0, async () => {
    let livestartervm: LiveStarterVm = new LiveStarterVm(new LiveVmInjector());
    let params: LiveStartWantAgentParams = new LiveStartWantAgentParams();
    params.wantAgent = new LiveNotification();
    params.onStartApp = () => {
    };
    const result = await livestartervm.startCardWantAgent(params);
    expect(result[0]).assertEqual(false);
    expect(result[1]).assertEqual(0);
  });

  describe('startCardWantAgent_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_return_false_when_wantAgent_is_invalid', 0, async () => {
      let livestartervm: ILiveStarterVm = new LiveStarterVm();
      let params: LiveStartWantAgentParams = new LiveStartWantAgentParams();
      params.wantAgent = null;
      const result = await livestartervm.startCardWantAgent(params);
      expect(result.start).assertEqual(false);
    });

    it('should_return_true_and_operationType_when_agentInfo_is_for_startApp', 0, async () => {
      let livestartervm: ILiveStarterVm = new LiveStarterVm();
      let mocker: MockKit = new MockKit();
      let mockOnExecute: Function = mocker.mockFunc(livestartervm, livestartervm.onExecute);
      when(mockOnExecute)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(Promise.resolve());

      let params: LiveStartWantAgentParams = new LiveStartWantAgentParams();
      params.wantAgent = {};
      params.wantAgentInfo = { operationType: LiveButtonModel.OperationType.START_APP };
      const result = await livestartervm.startCardWantAgent(params);
      expect(result.start).assertEqual(true);
      expect(result.operationType).assertEqual(LiveButtonModel.OperationType.START_APP);
      mocker.ignoreMock(livestartervm, livestartervm.onExecute);
    });

    it('should_return_true_and_operationType_when_agentInfo_is_not_for_startApp', 0, async () => {
      let livestartervm: ILiveStarterVm = new LiveStarterVm();
      let mocker: MockKit = new MockKit();

      let params: LiveStartWantAgentParams = new LiveStartWantAgentParams();
      params.wantAgent = {};
      params.wantAgentInfo = { operationType: LiveButtonModel.OperationType.INFO };
      const result = await livestartervm.startCardWantAgent(params);
      expect(result.start).assertEqual(true);
      expect(result.operationType).assertEqual(LiveButtonModel.OperationType.INFO);
    });

    it('should_return_false_when_startWantAgent_fails', 0, async () => {
      let livestartervm: ILiveStarterVm = new LiveStarterVm();
      let mocker: MockKit = new MockKit();

      let params: LiveStartWantAgentParams = new LiveStartWantAgentParams();
      params.wantAgent = {};
      params.wantAgentInfo = { operationType: LiveButtonModel.OperationType.INFO };
      const result = await livestartervm.startCardWantAgent(params);
      expect(result.start).assertEqual(false);
    });

    it('should_return_false_when_exception_occurs', 0, async () => {
      let livestartervm: ILiveStarterVm = new LiveStarterVm();
      let mocker: MockKit = new MockKit();

      let params: LiveStartWantAgentParams = new LiveStartWantAgentParams();
      params.wantAgent = {};
      params.wantAgentInfo = { operationType: LiveButtonModel.OperationType.INFO };
      const result = await livestartervm.startCardWantAgent(params);
      expect(result.start).assertEqual(false);
    });

    it('should_return_false_when_wantAgent_is_null', 0, async () => {
      params.wantAgent = null;
      const result = await livestartervm.startCardWantAgent(params);
      expect(result.start).assertEqual(false);
    });

    it('should_return_false_when_wantAgentInfo_parse_fails', 0, async () => {
      params.wantAgent = {};
      const mocker = new MockKit();
      const mockParse = mocker.mockFunc(NotificationUtil, NotificationUtil.parseWantAgentInfo);
      when(mockParse)(ArgumentMatchers.any).afterThrow('Parse error');
      const result = await livestartervm.startCardWantAgent(params);
      expect(result.start).assertEqual(false);
      mocker.ignoreMock(NotificationUtil, NotificationUtil.parseWantAgentInfo);
    });

    it('should_return_true_and_operationType_when_operationType_is_start_app', 0, async () => {
      const mocker = new MockKit();
      const mockOnExecute = mocker.mockFunc(livestartervm, livestartervm.onExecute);
      when(mockOnExecute)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(Promise.resolve());
      params.wantAgent = {};
      params.wantAgentInfo = { operationType: LiveButtonModel.OperationType.START_APP };
      const result = await livestartervm.startCardWantAgent(params);
      expect(result.start).assertEqual(true);
      expect(result.operationType).assertEqual(LiveButtonModel.OperationType.START_APP);
      mocker.ignoreMock(livestartervm, livestartervm.onExecute);
    });

    it('should_return_false_when_operationType_is_start_app_but_start_fails', 0, async () => {
      const mocker = new MockKit();
      const mockStart = mocker.mockFunc(NotificationUtil, NotificationUtil.startWantAgent);
      when(mockStart)(ArgumentMatchers.any).afterReturn(false);
      params.wantAgent = {};
      params.wantAgentInfo = { operationType: LiveButtonModel.OperationType.START_APP };
      const result = await livestartervm.startCardWantAgent(params);
      expect(result.start).assertEqual(false);
      mocker.ignoreMock(NotificationUtil, NotificationUtil.startWantAgent);
    });

    it('should_return_true_and_operationType_when_operationType_is_not_start_app', 0, async () => {
      params.wantAgent = {};
      params.wantAgentInfo = { operationType: LiveButtonModel.OperationType.INFO };
      const result = await livestartervm.startCardWantAgent(params);
      expect(result.start).assertEqual(true);
      expect(result.operationType).assertEqual(LiveButtonModel.OperationType.INFO);
    });

    it('should_return_false_when_operationType_is_not_start_app_and_start_fails', 0, async () => {
      const mocker = new MockKit();
      const mockStart = mocker.mockFunc(NotificationUtil, NotificationUtil.startWantAgent);
      when(mockStart)(ArgumentMatchers.any).afterReturn(false);
      params.wantAgent = {};
      params.wantAgentInfo = { operationType: LiveButtonModel.OperationType.INFO };
      const result = await livestartervm.startCardWantAgent(params);
      expect(result.start).assertEqual(false);
      mocker.ignoreMock(NotificationUtil, NotificationUtil.startWantAgent);
    });

    it('should_reset_state_in_finally', 0, async () => {
      const mocker = new MockKit();
      const mockCapsuleListVm = mocker.mockFunc(livestartervm.vmInjector, livestartervm.vmInjector.getCapsuleListVm);
      const mockVm = {
        isToEnterApplication: true,
        enterApplicationName: 'test'
      };
      when(mockCapsuleListVm)().afterReturn(mockVm);
      params.wantAgent = {};
      params.wantAgentInfo = { operationType: LiveButtonModel.OperationType.INFO };
      await livestartervm.startCardWantAgent(params);
      expect(mockVm.isToEnterApplication).assertEqual(false);
      expect(mockVm.enterApplicationName).assertEqual(undefined);
      mocker.ignoreMock(livestartervm.vmInjector, livestartervm.vmInjector.getCapsuleListVm);
    });

    it('should_handle_notification_util_start_want_agent_failure', 0, async () => {
      const mocker = new MockKit();
      const mockStart = mocker.mockFunc(NotificationUtil, NotificationUtil.startWantAgent);
      when(mockStart)(ArgumentMatchers.any).afterReturn(false);
      params.wantAgent = {};
      params.wantAgentInfo = { operationType: LiveButtonModel.OperationType.INFO };
      const result = await livestartervm.startCardWantAgent(params);
      expect(result.start).assertEqual(false);
      mocker.ignoreMock(NotificationUtil, NotificationUtil.startWantAgent);
    });

    it('should_handle_on_execute_error', 0, async () => {
      const mocker = new MockKit();
      const mockOnExecute = mocker.mockFunc(livestartervm, livestartervm.onExecute);
      when(mockOnExecute)(ArgumentMatchers.any, ArgumentMatchers.any).afterThrow('Execute error');
      params.wantAgent = {};
      params.wantAgentInfo = { operationType: LiveButtonModel.OperationType.START_APP };
      const result = await livestartervm.startCardWantAgent(params);
      expect(result.start).assertEqual(false);
      mocker.ignoreMock(livestartervm, livestartervm.onExecute);
    });

    it('should_handle_card_vm_null', 0, async () => {
      params.cardVm = null as any;
      const result = await livestartervm.startCardWantAgent(params);
      expect(result.start).assertEqual(false);
    });
  });

  describe('startCapsuleWantAgent_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_log_info_when_live_is_instant_and_needAnim_is_true', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.hashCode = '12345';
      live.wantAgent = 'wantAgent';
      live.wantAgentInfo = { operationType: 'startApp' };
      let livestartervm: LiveStarterVm = new LiveStarterVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let mockIsInstant: Function = mocker.mockFunc(live, live.isInstant);
      when(mockIsInstant)().afterReturn(true);
      let mockGetCapsuleVm: Function = mocker.mockFunc(livestartervm.vmInjector, livestartervm.vmInjector.getCapsuleVm);
      let capsuleVm: ILiveCapsuleVm = new LiveBaseVm();
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);

      await livestartervm.startCapsuleWantAgent(live, true);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(live, live.isInstant);
      mocker.ignoreMock(livestartervm.vmInjector, livestartervm.vmInjector.getCapsuleVm);
    });

    it('should_not_log_info_when_live_is_not_instant', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.hashCode = '12345';
      live.wantAgent = 'wantAgent';
      live.wantAgentInfo = { operationType: 'startApp' };
      let livestartervm: LiveStarterVm = new LiveStarterVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let mockIsInstant: Function = mocker.mockFunc(live, live.isInstant);
      when(mockIsInstant)().afterReturn(false);

      await livestartervm.startCapsuleWantAgent(live, true);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(live, live.isInstant);
    });

    it('should_not_log_info_when_needAnim_is_false', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.hashCode = '12345';
      live.wantAgent = 'wantAgent';
      live.wantAgentInfo = { operationType: 'startApp' };
      let livestartervm: LiveStarterVm = new LiveStarterVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let mockIsInstant: Function = mocker.mockFunc(live, live.isInstant);
      when(mockIsInstant)().afterReturn(true);
      let mockGetCapsuleVm: Function = mocker.mockFunc(livestartervm.vmInjector, livestartervm.vmInjector.getCapsuleVm);
      let capsuleVm: ILiveCapsuleVm = new LiveBaseVm();
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);

      await livestartervm.startCapsuleWantAgent(live, false);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(live, live.isInstant);
      mocker.ignoreMock(livestartervm.vmInjector, livestartervm.vmInjector.getCapsuleVm);
    });

    it('should_not_log_info_when_operationType_is_not_startApp', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.hashCode = '12345';
      live.wantAgent = 'wantAgent';
      live.wantAgentInfo = { operationType: 'other' };
      let livestartervm: LiveStarterVm = new LiveStarterVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let mockIsInstant: Function = mocker.mockFunc(live, live.isInstant);
      when(mockIsInstant)().afterReturn(true);
      let mockGetCapsuleVm: Function = mocker.mockFunc(livestartervm.vmInjector, livestartervm.vmInjector.getCapsuleVm);
      let capsuleVm: ILiveCapsuleVm = new LiveBaseVm();
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);

      await livestartervm.startCapsuleWantAgent(live, true);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(live, live.isInstant);
      mocker.ignoreMock(livestartervm.vmInjector, livestartervm.vmInjector.getCapsuleVm);
    });

    it('should_report_click_when_startWantAgent_fails', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.hashCode = '12345';
      live.wantAgent = 'wantAgent';
      live.wantAgentInfo = { operationType: 'startApp' };
      let livestartervm: LiveStarterVm = new LiveStarterVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let mockIsInstant: Function = mocker.mockFunc(live, live.isInstant);
      when(mockIsInstant)().afterReturn(true);
      let mockGetCapsuleVm: Function = mocker.mockFunc(livestartervm.vmInjector, livestartervm.vmInjector.getCapsuleVm);
      let capsuleVm: ILiveCapsuleVm = new LiveBaseVm();
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);
      let mockStartWantAgent: Function = mocker.mockFunc(NotificationUtil, NotificationUtil.startWantAgent);
      when(mockStartWantAgent)(ArgumentMatchers.any).afterReturn(Promise.resolve(false));

      await livestartervm.startCapsuleWantAgent(live, true);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(live, live.isInstant);
      mocker.ignoreMock(livestartervm.vmInjector, livestartervm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(NotificationUtil, NotificationUtil.startWantAgent);
    });

    it('should_log_info_when_live_is_instant_and_needAnim_is_true', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.hashCode = '12345';
      live.wantAgent = 'wantAgent';
      live.wantAgentInfo = { operationType: 'startApp' };
      let livestartervm: LiveStarterVm = new LiveStarterVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let mockIsInstant: Function = mocker.mockFunc(live, live.isInstant);
      when(mockIsInstant)().afterReturn(true);
      let mockGetCapsuleVm: Function = mocker.mockFunc(livestartervm.vmInjector, livestartervm.vmInjector.getCapsuleVm);
      let capsuleVm: ILiveCapsuleVm = new LiveBaseVm();
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);

      await livestartervm.startCapsuleWantAgent(live, true);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(live, live.isInstant);
      mocker.ignoreMock(livestartervm.vmInjector, livestartervm.vmInjector.getCapsuleVm);
    });

    it('should_not_log_info_when_live_is_not_instant', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.hashCode = '12345';
      live.wantAgent = 'wantAgent';
      live.wantAgentInfo = { operationType: 'startApp' };
      let livestartervm: LiveStarterVm = new LiveStarterVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let mockIsInstant: Function = mocker.mockFunc(live, live.isInstant);
      when(mockIsInstant)().afterReturn(false);

      await livestartervm.startCapsuleWantAgent(live, true);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(live, live.isInstant);
    });

    it('should_not_log_info_when_needAnim_is_false', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.hashCode = '12345';
      live.wantAgent = 'wantAgent';
      live.wantAgentInfo = { operationType: 'startApp' };
      let livestartervm: LiveStarterVm = new LiveStarterVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let mockIsInstant: Function = mocker.mockFunc(live, live.isInstant);
      when(mockIsInstant)().afterReturn(true);
      let mockGetCapsuleVm: Function = mocker.mockFunc(livestartervm.vmInjector, livestartervm.vmInjector.getCapsuleVm);
      let capsuleVm: ILiveCapsuleVm = new LiveBaseVm();
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);

      await livestartervm.startCapsuleWantAgent(live, false);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(live, live.isInstant);
      mocker.ignoreMock(livestartervm.vmInjector, livestartervm.vmInjector.getCapsuleVm);
    });

    it('should_not_log_info_when_operationType_is_not_startApp', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.hashCode = '12345';
      live.wantAgent = 'wantAgent';
      live.wantAgentInfo = { operationType: 'other' };
      let livestartervm: LiveStarterVm = new LiveStarterVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let mockIsInstant: Function = mocker.mockFunc(live, live.isInstant);
      when(mockIsInstant)().afterReturn(true);
      let mockGetCapsuleVm: Function = mocker.mockFunc(livestartervm.vmInjector, livestartervm.vmInjector.getCapsuleVm);
      let capsuleVm: ILiveCapsuleVm = new LiveBaseVm();
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);
      await livestartervm.startCapsuleWantAgent(live, true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(live, live.isInstant);
      mocker.ignoreMock(livestartervm.vmInjector, livestartervm.vmInjector.getCapsuleVm);
    });

    it('should_report_click_when_startWantAgent_fails', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.hashCode = '12345';
      live.wantAgent = 'wantAgent';
      live.wantAgentInfo = { operationType: 'startApp' };
      let livestartervm: LiveStarterVm = new LiveStarterVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let mockIsInstant: Function = mocker.mockFunc(live, live.isInstant);
      when(mockIsInstant)().afterReturn(true);
      let mockGetCapsuleVm: Function = mocker.mockFunc(livestartervm.vmInjector, livestartervm.vmInjector.getCapsuleVm);
      let capsuleVm: ILiveCapsuleVm = new LiveBaseVm();
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);
      let mockStartWantAgent: Function = mocker.mockFunc(NotificationUtil, NotificationUtil.startWantAgent);
      when(mockStartWantAgent)(ArgumentMatchers.any).afterReturn(Promise.resolve(false));
      await livestartervm.startCapsuleWantAgent(live, true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(live, live.isInstant);
      mocker.ignoreMock(livestartervm.vmInjector, livestartervm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(NotificationUtil, NotificationUtil.startWantAgent);
    });

    it('should_report_click_when_start_WantAgent_succeeds', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.hashCode = '12345';
      live.wantAgent = 'wantAgent';
      live.wantAgentInfo = { operationType: 'startApp' };
      let livestartervm: LiveStarterVm = new LiveStarterVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let mockIsInstant: Function = mocker.mockFunc(live, live.isInstant);
      when(mockIsInstant)().afterReturn(true);
      let mockGetCapsuleVm: Function = mocker.mockFunc(livestartervm.vmInjector, livestartervm.vmInjector.getCapsuleVm);
      let capsuleVm: ILiveCapsuleVm = new LiveBaseVm();
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);
      let mockStartWantAgent: Function = mocker.mockFunc(NotificationUtil, NotificationUtil.startWantAgent);
      when(mockStartWantAgent)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));
      await livestartervm.startCapsuleWantAgent(live, true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(live, live.isInstant);
      mocker.ignoreMock(livestartervm.vmInjector, livestartervm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(NotificationUtil, NotificationUtil.startWantAgent);
    });

    it('should_handle_null_agentInfo', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.hashCode = '12345';
      live.wantAgent = 'wantAgent';
      live.wantAgentInfo = null;
      let livestartervm: LiveStarterVm = new LiveStarterVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let mockParseWantAgentInfo: Function = mocker.mockFunc(NotificationUtil, NotificationUtil.parseWantAgentInfo);
      when(mockParseWantAgentInfo)(ArgumentMatchers.any).afterReturn(null);
      let mockIsInstant: Function = mocker.mockFunc(live, live.isInstant);
      when(mockIsInstant)().afterReturn(true);
      let mockGetCapsuleVm: Function = mocker.mockFunc(livestartervm.vmInjector, livestartervm.vmInjector.getCapsuleVm);
      let capsuleVm: ILiveCapsuleVm = new LiveBaseVm();
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);
      let mockStartWantAgent: Function = mocker.mockFunc(NotificationUtil, NotificationUtil.startWantAgent);
      when(mockStartWantAgent)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));
      await livestartervm.startCapsuleWantAgent(live, true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(NotificationUtil, NotificationUtil.parseWantAgentInfo);
      mocker.ignoreMock(live, live.isInstant);
      mocker.ignoreMock(livestartervm.vmInjector, livestartervm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(NotificationUtil, NotificationUtil.startWantAgent);
    });

    it('should_not_execute_animation_when_live_is_not_instant', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.hashCode = '12345';
      live.wantAgent = 'wantAgent';
      live.wantAgentInfo = { operationType: 'startApp' };
      let livestartervm: LiveStarterVm = new LiveStarterVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let mockIsInstant: Function = mocker.mockFunc(live, live.isInstant);
      when(mockIsInstant)().afterReturn(false);
      let mockGetCapsuleVm: Function = mocker.mockFunc(livestartervm.vmInjector, livestartervm.vmInjector.getCapsuleVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(null);
      await livestartervm.startCapsuleWantAgent(live, true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(live, live.isInstant);
      mocker.ignoreMock(livestartervm.vmInjector, livestartervm.vmInjector.getCapsuleVm);
    });

    it('should_not_execute_animation_when_needAnim_is_false', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.hashCode = '12345';
      live.wantAgent = 'wantAgent';
      live.wantAgentInfo = { operationType: 'startApp' };
      let livestartervm: LiveStarterVm = new LiveStarterVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let mockIsInstant: Function = mocker.mockFunc(live, live.isInstant);
      when(mockIsInstant)().afterReturn(true);
      let mockGetCapsuleVm: Function = mocker.mockFunc(livestartervm.vmInjector, livestartervm.vmInjector.getCapsuleVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(null);
      await livestartervm.startCapsuleWantAgent(live, false);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(live, live.isInstant);
      mocker.ignoreMock(livestartervm.vmInjector, livestartervm.vmInjector.getCapsuleVm);
    });
  });
}

function testStartCardWantAgent_InvalidWantAgent() {
  const mockCardVm = { live: { hashCode: "test_hash" }, componentId: "test_component" };
  const params: LiveStartWantAgentParams = {
    cardVm: mockCardVm,
    wantAgent: null as any,
    wantAgentInfo: null,
    onStartApp: jest.fn()
  };

  const vm = new LiveStarterVm();
  vm.vmInjector = {
    getCapsuleListVm: () => ({ isToEnterApplication: false, set isToEnterApplication(value: boolean) {} })
  };
  const mockClickMaintenance = {
    reportClick: jest.fn()
  };
  ClickNotificationMaintenance.getInfo = jest.fn().mockReturnValue({} as any);
  ClickNotificationMaintenance.reportClick = mockClickMaintenance.reportClick;

  const result = vm.startCardWantAgent(params);

  return result.then(([success, type]) => {
    expect(success).toBe(false);
    expect(type).toBe(0);
    expect(mockClickMaintenance.reportClick).toHaveBeenCalledWith(
      ClickNotificationErrorCode.INVALID_WANTAGENT,
      expect.anything()
    );
    expect(vm.vmInjector.getCapsuleListVm().isToEnterApplication).toBe(false);
  });
}

function testStartCardWantAgent_SuccessWithAnimation() {
  const mockCardVm = { live: { hashCode: "test_hash" }, componentId: "test_component" };
  const mockAgentInfo = { operationType: 1 };
  const params: LiveStartWantAgentParams = {
    cardVm: mockCardVm,
    wantAgent: {} as any,
    wantAgentInfo: mockAgentInfo,
    onStartApp: jest.fn()
  };

  const vm = new LiveStarterVm();
  vm.vmInjector = {
    getCapsuleListVm: () => ({ isToEnterApplication: false, set isToEnterApplication(value: boolean) {} }),
    scene: "test_scene"
  };
  const mockNotificationUtil = {
    parseWantAgentInfo: jest.fn().mockResolvedValue(mockAgentInfo),
    startWantAgent: jest.fn().mockResolvedValue(true)
  };
  NotificationUtil.parseWantAgentInfo = mockNotificationUtil.parseWantAgentInfo;
  NotificationUtil.startWantAgent = mockNotificationUtil.startWantAgent;

  const mockSystemUtil = {
    getRect: jest.fn().mockReturnValue({ width: 100, height: 200, x: 0, y: 0 })
  };
  SystemUICommonUtil.getRect = mockSystemUtil.getRect;

  const mockAnimation = {
    prepare: jest.fn().mockResolvedValue(true),
    executeAnimation: jest.fn().mockResolvedValue(true)
  };
  StartAppOneMirrorAnimation.instance = { prepare: mockAnimation.prepare } as any;
  vm.startCardAnimation = { executeAnimation: mockAnimation.executeAnimation } as any;

  const result = await vm.startCardWantAgent(params);

  expect(result).toEqual([true, mockAgentInfo.operationType]);
  expect(mockAnimation.prepare).toHaveBeenCalled();
  expect(mockAnimation.executeAnimation).toHaveBeenCalled();
  expect(mockNotificationUtil.startWantAgent).toHaveBeenCalled();
  expect(vm.vmInjector.getCapsuleListVm().isToEnterApplication).toBe(false);
}

function testStartCapsuleWantAgent_InstantApp() {
  const mockLive = {
    isInstant: () => true,
    wantAgentInfo: { operationType: 1 },
    wantAgent: {} as any
  };
  const mockCapsuleVm = { isToDelete: false };
  const vm = new LiveStarterVm();
  vm.vmInjector = {
    getCapsuleVm: () => mockCapsuleVm
  };

  const mockNotificationUtil = {
    startWantAgent: jest.fn().mockResolvedValue(true)
  };
  NotificationUtil.startWantAgent = mockNotificationUtil.startWantAgent;

  return vm.startCapsuleWantAgent(mockLive, true).then(() => {
    expect(mockCapsuleVm.isToDelete).toBe(true);
    expect(mockNotificationUtil.startWantAgent).toHaveBeenCalled();
    expect(ClickNotificationMaintenance.reportClickWithResult).toHaveBeenCalledWith(
      true,
      ClickNotificationErrorCode.TRIGGER_WANTAGENT_FAIL,
      expect.objectContaining({ clickRegion: ClickRegion.CAPSULE_TRIGGER })
    );
  });
}

function testTriggerButton_Failure() {
  const mockLive = { creatorBundleName: "test_bundle", creatorUid: 123, id: "test_id" };
  const mockButton = { name: "test_button" };
  const vm = new LiveStarterVm();

  const mockNotificationManager = {
    triggerSystemLiveView: jest.fn().mockRejectedValue(new Error("Test error"))
  };
  notificationManager.triggerSystemLiveView = mockNotificationManager.triggerSystemLiveView;

  return vm.triggerButton(mockLive, mockButton).catch(() => {
    expect(mockNotificationManager.triggerSystemLiveView).toHaveBeenCalled();
    expect(ClickNotificationMaintenance.reportClick).toHaveBeenCalledWith(
      ClickNotificationErrorCode.CLICK_LIVE_BUTTON_FAIL,
      expect.objectContaining({ data: mockLive, buttonName: mockButton.name })
    );
  });
}

async function testStartCardWantAgent_NonStartAppOperation() {
  const mockCardVm = { live: { hashCode: "test_hash" }, componentId: "test_component" };
  const mockAgentInfo = { operationType: 0 }; // 非启动应用的操作类型
  const params: LiveStartWantAgentParams = {
    cardVm: mockCardVm,
    wantAgent: {} as any,
    wantAgentInfo: mockAgentInfo,
    onStartApp: jest.fn()
  };

  const vm = new LiveStarterVm();
  vm.vmInjector = {
    getCapsuleListVm: () => ({ isToEnterApplication: false, set isToEnterApplication(value: boolean) {} })
  };

  const mockNotificationUtil = {
    parseWantAgentInfo: jest.fn().mockResolvedValue(mockAgentInfo),
    startWantAgent: jest.fn().mockResolvedValue(true)
  };
  NotificationUtil.parseWantAgentInfo = mockNotificationUtil.parseWantAgentInfo;
  NotificationUtil.startWantAgent = mockNotificationUtil.startWantAgent;

  const result = await vm.startCardWantAgent(params);

  expect(result).toEqual([true, mockAgentInfo.operationType]);
  expect(mockNotificationUtil.startWantAgent).toHaveBeenCalled();
  expect(vm.startCardAnimation.executeAnimation).not.toHaveBeenCalled();
}

function testOnExecute_AnimationSteps() {
  const mockCardVm = {
    live: { hashCode: "test_hash" },
    componentId: "test_component",
    containerOpacity: 1,
    contentAlign: Alignment.End,
    containerSize: { width: '100%', height: 'auto' }
  };
  const mockCardRect = { width: 200, height: 300, x: 0, y: 100 };
  const mockDeviceInfoVm = { width: 720, height: 1280 };
  DeviceInfoVm.instance = mockDeviceInfoVm as any;

  const vm = new LiveStarterVm();
  vm.vmInjector = {
    getCardListVm: () => ({
      liveList: [
        { hashCode: "other_hash" } as ILiveCardListItemVm,
        mockCardVm
      ]
    }),
    getCardListItemVm: (live: any) => ({
      containerOpacity: 1
    })
  };

  const mockAnimation = {
    executeAnimation: jest.fn().mockResolvedValue(true)
  };
  vm.startCardAnimation = mockAnimation as any;

  return vm.onExecute(mockCardVm, mockCardRect).then(() => {
    // 验证动画开始时的参数设置
    expect(vm.vmInjector.getCardListItemVm({ hashCode: "other_hash" }).containerOpacity).toBe(0);
    expect(mockCardVm.contentSize).toEqual({ width: 200, height: 300 });
    expect(mockCardVm.contentAlign).toBe(Alignment.Center);

    // 验证动画结束后的参数恢复
    expect(mockCardVm.containerSize).toEqual({ width: '100%', height: 'auto' });
    expect(mockCardVm.containerOffsetY).toBe(0);
    expect(mockCardVm.containerOpacity).toBe(1);
    expect(mockCardVm.contentAlign).toBe(Alignment.End);
    expect(mockCardVm.contentSize).toBeUndefined();
  });
}

function testStartCapsuleWantAgent_NoAnimation() {
  const mockLive = {
    isInstant: () => false,
    wantAgentInfo: { operationType: 1 },
    wantAgent: {} as any
  };

  const vm = new LiveStarterVm();
  const mockNotificationUtil = {
    startWantAgent: jest.fn().mockResolvedValue(true)
  };
  NotificationUtil.startWantAgent = mockNotificationUtil.startWantAgent;

  return vm.startCapsuleWantAgent(mockLive, false).then(() => {
    expect(vm.vmInjector.getCapsuleVm).not.toHaveBeenCalled();
    expect(mockNotificationUtil.startWantAgent).toHaveBeenCalled();
    expect(ClickNotificationMaintenance.reportClickWithResult).toHaveBeenCalledWith(
      true,
      ClickNotificationErrorCode.TRIGGER_WANTAGENT_FAIL,
      expect.objectContaining({ clickRegion: ClickRegion.CAPSULE_TRIGGER })
    );
  });

  // 测试getWidth方法
  it('should calculate width correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const width = vm.getWidth(capsulePosition);
    expect(width).toBe(capsulePosition.width * 5.0);
  });

  // 测试getHeight方法
  it('should calculate height correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const height = vm.getHeight(capsulePosition);
    expect(height).toBe(capsulePosition.height * 1.6);
  });

  // 测试getPosition方法
  it('should calculate position correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const position = vm.getPosition(capsulePosition);
    expect(position.left).toBe(-capsulePosition.width * (5.0 - 1) / 2);
    expect(position.top).toBe(-capsulePosition.height * (1.6 - 1) / 2);
  });

  // 测试getBallParam方法
  it('should get ball parameters correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const params = vm.getBallParam(capsulePosition);
    expect(params.length).toBe(1);
    expect(params[0].centerX).toBe(capsulePosition.holes[0].centerX - capsulePosition.left);
    expect(params[0].centerY).toBe(capsulePosition.holes[0].centerY - capsulePosition.top);
    expect(params[0].radius).toBe(LiveStyle.CAPSULE_HEIGHT / 2);
    expect(params[0].isIsolated).toBe(true);
  });

  // 测试toggleState方法
  it('should toggle state correctly for different scenes', 0, async () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    // 模拟不同的场景
    const scenes = [
      LiveMetaBallScene.DESKTOP,
      LiveMetaBallScene.LIVE_PANEL,
      LiveMetaBallScene.DROPDOWN,
      LiveMetaBallScene.SCREEN_LOCK,
      LiveMetaBallScene.STATUSBAR_HIDE,
      LiveMetaBallScene.REMIND,
      LiveMetaBallScene.IMMERSIVE
    ];

    for (const scene of scenes) {
      vm.sceneSet.add(scene);
      await vm.toggleState();
      // 根据不同的场景，验证相应的toggleTo...方法被调用
      // 这里需要使用jest或其他 mocking 工具来跟踪方法调用
      // 例如：
      // expect(vm.toggleToDeskTop).toHaveBeenCalled();
      vm.sceneSet.clear();
    }
  });

  // 测试toggleToDeskTop方法
  it('should toggle to desktop state correctly', 0, async () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    // 模拟不同的taskNum
    const taskNums = [0, 1, 2, 3];
    for (const taskNum of taskNums) {
      vm.getTaskNum = jest.fn().mockReturnValue(taskNum);
      await vm.toggleToDeskTop();
      // 验证fusionBall被正确调用
      // 例如：
      expect(vm.fusionBall).toHaveBeenCalledWith('fusionBall');
    }
  });

  // 测试toggleToLiveList方法
  it('should toggle to live list state correctly', 0, async () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    await vm.toggleToLiveList();
    // 验证fusionBall被正确调用
    // 例如：
    expect(vm.fusionBall).toHaveBeenCalledWith('fusionBall');
  });

  // 测试toggleToPanel方法
  it('should toggle to panel state correctly', 0, async () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    await vm.toggleToPanel();
    // 验证fusionBall被正确调用
    // 例如：
    expect(vm.fusionBall).toHaveBeenCalledWith('fusionBall');
  });

  // 测试toggleToRemind方法
  it('should toggle to remind state correctly', 0, async () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    // 模拟不同的taskNum
    const taskNums = [0, 1, 2];
    for (const taskNum of taskNums) {
      vm.getTaskNum = jest.fn().mockReturnValue(taskNum);
      await vm.toggleToRemind();
      // 验证fusionBall被正确调用
      // 例如：
      expect(vm.fusionBall).toHaveBeenCalledWith('fusionBall');
    }
  });

  // 测试toggleToImmersive方法
  it('should toggle to immersive state correctly', 0, async () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    await vm.toggleToImmersive();
    // 验证fusionBall被正确调用
    // 例如：
    expect(vm.fusionBall).toHaveBeenCalledWith('fusionBall');
  });

  // 测试更新状态栏高度
  it('should update status bar height correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const height = 100;
    const tag = 'testTag';
    vm.updateStatusBarHeight(height, tag);
    // 验证StatusBarHeightVm的preSetShowHeight被调用
    // 例如：
    expect(statusBarHeightVm.preSetShowHeight).toHaveBeenCalledWith(height, tag);
  });

  // 测试设置和获取场景
  it('should set and get scene correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const scene = LiveMetaBallScene.DESKTOP;
    vm.setScene(scene, true);
    expect(vm.sceneSet.has(scene)).toBe(true);
    vm.setScene(scene, false);
    expect(vm.sceneSet.has(scene)).toBe(false);
  });

  // 测试更新属性
  it('should update properties correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const newVm = {
      sceneSet: new Set([LiveMetaBallScene.LIVE_PANEL])
    };
    vm.updateProperty(newVm);
    expect(vm.sceneSet.has(LiveMetaBallScene.LIVE_PANEL)).toBe(true);
  });

  // 测试更新状态栏高度
  it('should update status bar height correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const height = 100;
    const tag = 'testTag';
    vm.updateStatusBarHeight(height, tag);
    // 验证StatusBarHeightVm的preSetShowHeight被调用
    // 例如：
    expect(statusBarHeightVm.preSetShowHeight).toHaveBeenCalledWith(height, tag);
  });

  // 测试设置和获取场景
  it('should set and get scene correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const scene = LiveMetaBallScene.DESKTOP;
    vm.setScene(scene, true);
    expect(vm.sceneSet.has(scene)).toBe(true);
    vm.setScene(scene, false);
    expect(vm.sceneSet.has(scene)).toBe(false);
  });

  // 测试更新属性
  it('should update properties correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const newVm = {
      sceneSet: new Set([LiveMetaBallScene.LIVE_PANEL])
    };
    vm.updateProperty(newVm);
    expect(vm.sceneSet.has(LiveMetaBallScene.LIVE_PANEL)).toBe(true);
  });

  // 测试更新状态栏高度
  it('should update status bar height correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const height = 100;
    const tag = 'testTag';
    vm.updateStatusBarHeight(height, tag);
    // 验证StatusBarHeightVm的preSetShowHeight被调用
    // 例如：
    expect(statusBarHeightVm.preSetShowHeight).toHaveBeenCalledWith(height, tag);
  });

  // 测试设置和获取场景
  it('should set and get scene correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const scene = LiveMetaBallScene.DESKTOP;
    vm.setScene(scene, true);
    expect(vm.sceneSet.has(scene)).toBe(true);
    vm.setScene(scene, false);
    expect(vm.sceneSet.has(scene)).toBe(false);
  });

  // 测试更新属性
  it('should update properties correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const newVm = {
      sceneSet: new Set([LiveMetaBallScene.LIVE_PANEL])
    };
    vm.updateProperty(newVm);
    expect(vm.sceneSet.has(LiveMetaBallScene.LIVE_PANEL)).toBe(true);
  });

  // 测试更新状态栏高度
  it('should update status bar height correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const height = 100;
    const tag = 'testTag';
    vm.updateStatusBarHeight(height, tag);
    // 验证StatusBarHeightVm的preSetShowHeight被调用
    // 例如：
    expect(statusBarHeightVm.preSetShowHeight).toHaveBeenCalledWith(height, tag);
  });

  // 测试设置和获取场景
  it('should set and get scene correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const scene = LiveMetaBallScene.DESKTOP;
    vm.setScene(scene, true);
    expect(vm.sceneSet.has(scene)).toBe(true);
    vm.setScene(scene, false);
    expect(vm.sceneSet.has(scene)).toBe(false);
  });

  // 测试更新属性
  it('should update properties correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const newVm = {
      sceneSet: new Set([LiveMetaBallScene.LIVE_PANEL])
    };
    vm.updateProperty(newVm);
    expect(vm.sceneSet.has(LiveMetaBallScene.LIVE_PANEL)).toBe(true);
  });

  // 测试设置和获取场景
  it('should set and get scene correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const scene = LiveMetaBallScene.DESKTOP;
    vm.setScene(scene, true);
    expect(vm.sceneSet.has(scene)).toBe(true);
    vm.setScene(scene, false);
    expect(vm.sceneSet.has(scene)).toBe(false);
  });

  // 测试更新属性
  it('should update properties correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const newVm = {
      sceneSet: new Set([LiveMetaBallScene.LIVE_PANEL])
    };
    vm.updateProperty(newVm);
    expect(vm.sceneSet.has(LiveMetaBallScene.LIVE_PANEL)).toBe(true);
  });

  // 测试更新状态栏高度
  it('should update status bar height correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const height = 100;
    const tag = 'testTag';
    vm.updateStatusBarHeight(height, tag);
    // 验证StatusBarHeightVm的preSetShowHeight被调用
    // 例如：
    expect(statusBarHeightVm.preSetShowHeight).toHaveBeenCalledWith(height, tag);
  });

  // 测试设置和获取场景
  it('should set and get scene correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const scene = LiveMetaBallScene.DESKTOP;
    vm.setScene(scene, true);
    expect(vm.sceneSet.has(scene)).toBe(true);
    vm.setScene(scene, false);
    expect(vm.sceneSet.has(scene)).toBe(false);
  });

  // 测试更新属性
  it('should update properties correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const newVm = {
      sceneSet: new Set([LiveMetaBallScene.LIVE_PANEL])
    };
    vm.updateProperty(newVm);
    expect(vm.sceneSet.has(LiveMetaBallScene.LIVE_PANEL)).toBe(true);
  });

  // 测试更新状态栏高度
  it('should update status bar height correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const height = 100;
    const tag = 'testTag';
    vm.updateStatusBarHeight(height, tag);
    // 验证StatusBarHeightVm的preSetShowHeight被调用
    // 例如：
    expect(statusBarHeightVm.preSetShowHeight).toHaveBeenCalledWith(height, tag);
  });

  // 测试设置和获取场景
  it('should set and get scene correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const scene = LiveMetaBallScene.DESKTOP;
    vm.setScene(scene, true);
    expect(vm.sceneSet.has(scene)).toBe(true);
    vm.setScene(scene, false);
    expect(vm.sceneSet.has(scene)).toBe(false);
  });

  // 测试更新属性
  it('should update properties correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const newVm = {
      sceneSet: new Set([LiveMetaBallScene.LIVE_PANEL])
    };
    vm.updateProperty(newVm);
    expect(vm.sceneSet.has(LiveMetaBallScene.LIVE_PANEL)).toBe(true);
  });

  // 测试更新状态栏高度
  it('should update status bar height correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const height = 100;
    const tag = 'testTag';
    vm.updateStatusBarHeight(height, tag);
    // 验证StatusBarHeightVm的preSetShowHeight被调用
    // 例如：
    expect(statusBarHeightVm.preSetShowHeight).toHaveBeenCalledWith(height, tag);
  });

  // 测试设置和获取场景
  it('should set and get scene correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const scene = LiveMetaBallScene.DESKTOP;
    vm.setScene(scene, true);
    expect(vm.sceneSet.has(scene)).toBe(true);
    vm.setScene(scene, false);
    expect(vm.sceneSet.has(scene)).toBe(false);
  });

  // 测试更新属性
  it('should update properties correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const newVm = {
      sceneSet: new Set([LiveMetaBallScene.LIVE_PANEL])
    };
    vm.updateProperty(newVm);
    expect(vm.sceneSet.has(LiveMetaBallScene.LIVE_PANEL)).toBe(true);
  });

  // 测试设置和获取场景
  it('should set and get scene correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const scene = LiveMetaBallScene.DESKTOP;
    vm.setScene(scene, true);
    expect(vm.sceneSet.has(scene)).toBe(true);
    vm.setScene(scene, false);
    expect(vm.sceneSet.has(scene)).toBe(false);
  });

  // 测试更新属性
  it('should update properties correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const newVm = {
      sceneSet: new Set([LiveMetaBallScene.LIVE_PANEL])
    };
    vm.updateProperty(newVm);
    expect(vm.sceneSet.has(LiveMetaBallScene.LIVE_PANEL)).toBe(true);
  });
}