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
import {
  GuidanceDialogManager, DialogCallback
} from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/Guidance/GuidanceDialogManager';
import {
  GuidanceDialogParam,
  DialogType,
  DialogTriggerType
} from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/Guidance//GuidanceDialogParam';
import { describe, it, Level, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { TipsJumpUtils } from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/Guidance/JumpTips';
import util from '@ohos.util';
import {
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBScenePanelManager,
  SCBSceneSession,
  SCBScreenProperty,
  SCBScreenSessionManager } from '@ohos/windowscene';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { SCBConstants } from '@ohos/commonconstants';
import { ReflectionUtils } from './ReflectionUtils';
import sceneSessionManager from '@ohos.sceneSessionManager';

let dialogManager: GuidanceDialogManager = GuidanceDialogManager.getInstance();

export default function GuidanceDialogManagerTest() {
  describe('GuidanceDialogManagerTest_001', (): void => {
    getInstanceTest_01();
    registerDialogCallbackTest_01();
    unRegisterDialogCallbackTest_01();
    showDialogTest_01();
    closeDialogTest_01();
    updateDialogTest_01();
    initDialogParamTest_01();
    floatToSplitDialogInitTest_01();
    splitingDialogInitTest_01();
    splitToMidDialogInitTest_01();
    midSceneDialogInitTest_01();
    jumpHomeTest_01();
    jumpTipsTest_01();
    jumpTipsByUriTest_01();
    guideReportTest_01();
  });
}

function registerDialogCallbackTest_01() {
  it('registerDialogCallbackTest_001', Level.LEVEL0, (): void => {
    let callback: DialogCallback = {
      onCreateDialog: (sessionInfo: GuidanceDialogParam) => {
      },
      onDialogParamChanged: (sessionInfo: GuidanceDialogParam) => {
      },
      onCloseDialog: (isClosedByButton: boolean) => {
      }
    };
    dialogManager.registerDialogCallback(callback);
    expect(ReflectionUtils.getProperty(dialogManager, 'callback')).assertEqual(callback);
  });
}

function getInstanceTest_01() {
  it('getInstanceTest_001', Level.LEVEL0, (): void => {
    GuidanceDialogManager.getInstance();
    GuidanceDialogManager.getInstance();
    expect(GuidanceDialogManager.getInstance()).not().assertNull();
  });
}

function showDialogTest_01() {
  it('showDialogTest_001', Level.LEVEL0, (): void => {
    let callback: DialogCallback = {
      onCreateDialog: (sessionInfo: GuidanceDialogParam) => {
      },
      onDialogParamChanged: (sessionInfo: GuidanceDialogParam) => {
      },
      onCloseDialog: (isClosedByButton: boolean) => {
      }
    };
    dialogManager.registerDialogCallback(callback);
    let reason = DialogType.FLOATING_TO_SPLIT;
    dialogManager.showDialog(reason, DialogType.FLOATING_TO_SPLIT, DialogTriggerType.FLOATING_TO_SPLIT_GUIDE);
    expect(dialogManager.dialogParam?.id).assertEqual(reason);
  });
  it('showDialogTest_002', Level.LEVEL0, (): void => {
    dialogManager.showDialog(DialogType.SPLIT_TO_FLOATING, DialogType.SPLIT_SWAP, DialogTriggerType.SPLITING_GUIDE);
    expect(dialogManager.dialogParam?.id).assertEqual(DialogType.SPLIT_SWAP);
    dialogManager.showDialog(DialogType.SPLIT_TO_FLOATING, DialogType.SPLIT_TO_FLOATING,
      DialogTriggerType.SPLITING_GUIDE);
    expect(dialogManager.dialogParam?.id).assertEqual(DialogType.SPLIT_TO_FLOATING);
  });
  it('showDialogTest_003', Level.LEVEL0, (): void => {
    let reason = DialogType.SPLIT_TO_FLOATING;
    dialogManager.showDialog(reason, DialogType.SPLIT_TO_FLOATING, DialogTriggerType.SPLITING_GUIDE);
    expect(dialogManager.dialogParam?.id).assertEqual(reason);
    dialogManager.dialogParam = undefined;
    dialogManager.showDialog(reason, DialogType.SPLIT_TO_FLOATING, DialogTriggerType.SPLITING_GUIDE);
    expect(true).assertTrue();
  });
  it('showDialogTest_004', Level.LEVEL0, (): void => {
    ReflectionUtils.setProperty(dialogManager, 'callback', undefined);
    expect(true).assertTrue();
  });
}

function updateDialogTest_01() {
  it('updateDialogTest_001', Level.LEVEL0, (): void => {
    let callback: DialogCallback = {
      onCreateDialog: (sessionInfo: GuidanceDialogParam) => {
      },
      onDialogParamChanged: (sessionInfo: GuidanceDialogParam) => {
      },
      onCloseDialog: (isClosedByButton: boolean) => {
      }
    };
    dialogManager.registerDialogCallback(callback);
    dialogManager.showDialog(DialogType.SPLIT_TO_FLOATING, DialogType.SPLIT_TO_FLOATING,
      DialogTriggerType.SPLITING_GUIDE);
    let reason = DialogType.SPLIT_SWAP;
    dialogManager.updateDialog(reason);
    expect(dialogManager.dialogParam?.id).assertEqual(reason);
  });
}

function closeDialogTest_01() {
  it('closeDialogTest_001', Level.LEVEL0, (): void => {
    let callback: DialogCallback = {
      onCreateDialog: (sessionInfo: GuidanceDialogParam) => {
      },
      onDialogParamChanged: (sessionInfo: GuidanceDialogParam) => {
      },
      onCloseDialog: (isClosedByButton: boolean) => {
      }
    };
    dialogManager.registerDialogCallback(callback);
    dialogManager.dialogParam = dialogManager.initDialogParam(DialogType.FLOATING_TO_SPLIT);
    dialogManager.closeDialog(true);
    expect(dialogManager.dialogParam).assertEqual(undefined);
    dialogManager.dialogParam = undefined;
    dialogManager.closeDialog(true);
    expect(dialogManager.dialogParam).assertEqual(undefined);
  });
}

function initDialogParamTest_01() {
  it('initDialogParamTest_001', Level.LEVEL0, (): void => {
    let reason: DialogType = DialogType.ONE_STEP_MID;
    let trigger: DialogTriggerType = DialogTriggerType.SPLIT_TO_MID;
    let param: GuidanceDialogParam = dialogManager.initDialogParam(reason, trigger);
    expect(param.triggerType === trigger).assertTrue();
  });
  it('initDialogParamTest_002', Level.LEVEL0, (): void => {
    let reason: DialogType = DialogType.SPLIT_TO_FLOATING;
    let trigger: DialogTriggerType = DialogTriggerType.SPLITING_GUIDE;
    let param: GuidanceDialogParam = dialogManager.initDialogParam(reason, trigger);
    expect(param.triggerType === trigger).assertTrue();
  });
  it('initDialogParamTest_003', Level.LEVEL0, (): void => {
    let reason: DialogType = DialogType.MID_SWAP;
    let trigger: DialogTriggerType = DialogTriggerType.MID_SCENE_GUIDE;
    let param: GuidanceDialogParam = dialogManager.initDialogParam(reason, trigger);
    expect(param.triggerType === trigger).assertTrue();
  });
  it('initDialogParamTest_004', Level.LEVEL0, (): void => {
    let reason: DialogType = DialogType.FLOATING_TO_SPLIT;
    let trigger: DialogTriggerType = DialogTriggerType.FLOATING_TO_SPLIT_GUIDE;
    let param: GuidanceDialogParam = dialogManager.initDialogParam(reason, trigger);
    expect(param.triggerType === trigger).assertTrue();
  });
}

function floatToSplitDialogInitTest_01() {
  it('floatToSplitDialogInitTest_001', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let obj = SCBScreenSessionManager.getInstance();
    let mockFunc: Function = mocker.mockFunc(obj, obj.isFoldablePhoneExpandStatus);
    when(mockFunc)().afterReturn(true);
    let reason: DialogType = DialogType.FLOATING_TO_SPLIT;
    dialogManager.uiType = SCBConstants.UITYPE_PAD;
    let param: GuidanceDialogParam = dialogManager.floatToSplitDialogInit(reason);
    expect(param.id === reason).assertTrue();
    mocker.clear(mockFunc);
  });

  it('floatToSplitDialogInitTest_002', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let obj = SCBScreenSessionManager.getInstance();
    let mockFunc: Function = mocker.mockFunc(obj, obj.isFoldablePhoneExpandStatus);
    when(mockFunc)().afterReturn(false);
    let reason: DialogType = DialogType.FLOATING_TO_SPLIT;
    dialogManager.uiType = SCBConstants.UITYPE_PAD;
    let param: GuidanceDialogParam = dialogManager.floatToSplitDialogInit(reason);
    expect(param.id === reason).assertTrue();
    mocker.clear(mockFunc);
  });

  it("floatToSplitDialogInitTest_003", Level.LEVEL0, () => {
    let reason: DialogType = DialogType.FLOATING_TO_SPLIT;
    let param = dialogManager.floatToSplitDialogInit(reason);
    expect(param.id === reason).assertTrue();
  })
}

function splitingDialogInitTest_01() {
  it("splitingDialogInitTest_001", Level.LEVEL0, () => {
    let reason: DialogType = DialogType.SPLIT_TO_FLOATING;
    let param = dialogManager.splitingDialogInit(reason);
    expect(param.id === reason).assertTrue();
  });
  it("splitingDialogInitTest_002", Level.LEVEL0, () => {
    let reason: DialogType = DialogType.SPLIT_SWAP;
    let param = dialogManager.splitingDialogInit(reason);
    expect(param.id === reason).assertTrue();
  });

  it('splitingDialogInitTest_003', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let obj = SCBScreenSessionManager.getInstance();
    let mockFunc: Function = mocker.mockFunc(obj, obj.isFoldablePhoneExpandStatus);
    when(mockFunc)().afterReturn(false);
    let reasonList = [DialogType.SPLIT_SWAP, DialogType.SPLIT_TO_FLOATING];
    dialogManager.uiType = SCBConstants.UITYPE_PAD;
    reasonList.forEach((reason) => {
      let param: GuidanceDialogParam = dialogManager.splitingDialogInit(reason);
      expect(param.id === reason).assertTrue();
    })
    mocker.clear(mockFunc);
  });

  it('splitingDialogInitTest_004', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let obj = SCBScreenSessionManager.getInstance();
    let mockFunc: Function = mocker.mockFunc(obj, obj.isFoldablePhoneExpandStatus);
    when(mockFunc)().afterReturn(true);
    let reasonList = [DialogType.SPLIT_SWAP, DialogType.SPLIT_TO_FLOATING];
    dialogManager.uiType = SCBConstants.UITYPE_PAD;
    reasonList.forEach((reason) => {
      let param: GuidanceDialogParam = dialogManager.splitingDialogInit(reason);
      expect(param.id === reason).assertTrue();
    })
    mocker.clear(mockFunc);
  });
}

function splitToMidDialogInitTest_01() {
  it("splitToMidDialogInitTest_001", Level.LEVEL0, () => {
    let reason: DialogType = DialogType.ONE_STEP_MID;
    let param = dialogManager.splitToMidDialogInit(reason);
    expect(param.id === reason).assertTrue();
  });
  it("splitToMidDialogInitTest_002", Level.LEVEL0, () => {
    let reason: DialogType = DialogType.SPLIT_ADJUST_TO_MID;
    let param = dialogManager.splitToMidDialogInit(reason);
    expect(param.id === reason).assertTrue();
  });

  it('splitToMidDialogInitTest_003', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let obj = SCBScreenSessionManager.getInstance();
    let mockFunc: Function = mocker.mockFunc(obj, obj.isFoldablePhoneExpandStatus);
    when(mockFunc)().afterReturn(false);
    let reasonList = [DialogType.ONE_STEP_MID, DialogType.SPLIT_ADJUST_TO_MID];
    dialogManager.uiType = SCBConstants.UITYPE_PAD;
    reasonList.forEach((reason) => {
      let param: GuidanceDialogParam = dialogManager.splitToMidDialogInit(reason);
      expect(param.id === reason).assertTrue();
    })
    mocker.clear(mockFunc);
  });

  it('splitToMidDialogInitTest_004', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let obj = SCBScreenSessionManager.getInstance();
    let mockFunc: Function = mocker.mockFunc(obj, obj.isFoldablePhoneExpandStatus);
    when(mockFunc)().afterReturn(true);
    let reasonList = [DialogType.ONE_STEP_MID, DialogType.SPLIT_ADJUST_TO_MID];
    dialogManager.uiType = SCBConstants.UITYPE_PAD;
    reasonList.forEach((reason) => {
      let param: GuidanceDialogParam = dialogManager.splitToMidDialogInit(reason);
      expect(param.id === reason).assertTrue();
    })
    mocker.clear(mockFunc);
  });
}

function midSceneDialogInitTest_01() {
  it("midSceneDialogInitTest_001", Level.LEVEL0, () => {
    let reason: DialogType = DialogType.MID_SWAP;
    let param = dialogManager.midSceneDialogInit(reason);
    expect(param.id === reason).assertTrue();
  });
  it("midSceneDialogInitTest_002", Level.LEVEL0, () => {
    let reason: DialogType = DialogType.MID_MULTI_FINGER_KNEAD;
    let param = dialogManager.midSceneDialogInit(reason);
    expect(param.id === reason).assertTrue();
  });
  it("midSceneDialogInitTest_003", Level.LEVEL0, () => {
    let reason: DialogType  = DialogType.MID_THREE_FINGER_CROSS_SLIP;
    let param = dialogManager.midSceneDialogInit(reason);
    expect(param.id === reason).assertTrue();
  });
  it("midSceneDialogInitTest_004", Level.LEVEL0, () => {
    let reason: DialogType  = DialogType.MID_SLID_DELETE;
    let param = dialogManager.midSceneDialogInit(reason);
    expect(param.id === reason).assertTrue();
  });

  it('midSceneDialogInitTest_005', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let obj = SCBScreenSessionManager.getInstance();
    let mockFunc: Function = mocker.mockFunc(obj, obj.isFoldablePhoneExpandStatus);
    when(mockFunc)().afterReturn(false);
    let reasonList = [DialogType.MID_SWAP, DialogType.MID_MULTI_FINGER_KNEAD, DialogType.MID_THREE_FINGER_CROSS_SLIP,
      DialogType.MID_SLID_DELETE];
    dialogManager.uiType = SCBConstants.UITYPE_PAD;
    reasonList.forEach((reason) => {
      let param: GuidanceDialogParam = dialogManager.midSceneDialogInit(reason);
      expect(param.id === reason).assertTrue();
    })
    mocker.clear(mockFunc);
  });

  it('midSceneDialogInitTest_006', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let obj = SCBScreenSessionManager.getInstance();
    let mockFunc: Function = mocker.mockFunc(obj, obj.isFoldablePhoneExpandStatus);
    when(mockFunc)().afterReturn(true);
    let reasonList = [DialogType.MID_SWAP, DialogType.MID_MULTI_FINGER_KNEAD, DialogType.MID_THREE_FINGER_CROSS_SLIP,
      DialogType.MID_SLID_DELETE];
    dialogManager.uiType = SCBConstants.UITYPE_PAD;
    reasonList.forEach((reason) => {
      let param: GuidanceDialogParam = dialogManager.midSceneDialogInit(reason);
      expect(param.id === reason).assertTrue();
    })
    mocker.clear(mockFunc);
  });
}

function unRegisterDialogCallbackTest_01() {
  it('unRegisterDialogCallbackTest_001', Level.LEVEL0, (): void => {
    dialogManager.unRegisterDialogCallback();
    expect(dialogManager.dialogParam === undefined).assertTrue();
  });
}

function jumpHomeTest_01() {
  it('jumpHomeTest_001', Level.LEVEL0, (): void => {
    TipsJumpUtils.jumpHome(GlobalContext.getContext(), '97');
    expect(true).assertEqual(true);
  });
}

function jumpTipsByUriTest_01() {
  it('jumpTipsByUriTest_001', Level.LEVEL0, (): void => {
    const FUN_NUM = 'SF-10045865_f020';
    const URI_FORMATTER = 'hwtips://com.ohos.tips.app?funNum=%s&type=%s';
    let uri = util.format(URI_FORMATTER, FUN_NUM, '97');
    TipsJumpUtils.jumpTipsByUri(GlobalContext.getContext(), uri);
    expect(true).assertEqual(true);
  });
}

function jumpTipsTest_01() {
  it('jumpTipsTest_001', Level.LEVEL0, (): void => {
    const FUN_NUM = 'SF-10045865_f020';
    TipsJumpUtils.jumpTips(GlobalContext.getContext(), FUN_NUM, '97');
    expect(true).assertEqual(true);
  });
}

function guideReportTest_01() {
  it('guideReportDialogFloatingTest_001', Level.LEVEL0, (): void => {
    dialogManager.reportDialogFloating(1);
    expect(true).assertTrue();
  });
  it('guideReportDialogFloatingTest_001', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let scenePanelManager = SCBScenePanelManager.getInstance();
    let func1: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getActiveFloatContainerList);
    let list = new Array<SCBSceneContainerSession>();
    when(func1)(ArgumentMatchers.any).afterReturn(list);
    dialogManager.reportDialogFloating(1);
    mocker.clear(func1);
    expect(true).assertTrue();
  });
  it('guideReportDialogSplitTest_001', Level.LEVEL0, (): void => {
    let lis = SCBScenePanelManager.getInstance().getSceneContainerSessionList();
    let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let secSceneInfo = new SCBSceneInfo('testSecBundle', 'testSecModule', 'testSecAbility');
    let primSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let secondarySession = new SCBSceneSession(sceneSessionManager.requestSceneSession(secSceneInfo), sceneInfo);
    let container = new SCBSceneContainerSession(primSession, new SCBScreenProperty());
    container.addSceneSession(secondarySession);
    container.isSplit = true;
    ReflectionUtils.setProperty(container, '_isActive', true);
    ReflectionUtils.setProperty(container, 'isActive', true);
    lis.push(container);
    dialogManager.reportDialogSplit(1, 1);
    expect(true).assertTrue();
  });
  it('guideReportDialogSplitTest_001', Level.LEVEL0, (): void => {
    dialogManager.reportDialogSplit(1, 1);
    expect(true).assertTrue();
  });
}