/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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
import sceneSessionManager from '@ohos.sceneSessionManager';
import { Level, when, it, MockKit, describe, expect, ArgumentMatchers } from '@ohos/hypium';
import { SCBPiPManager } from '../../../../main/ets/SceneBoard/scenemanager/pip/SCBPiPManager';
import { SCBSceneSessionManager,
  SCBSceneInfo,
  SCBSpecificSession
} from '@ohos/windowscene';
import { PipTemplate } from '../../../../main/ets/SceneBoard/scenemanager/pip/utils/PictureInPictureConstants';

export function SCBPiPManagerTest() {
  describe('SCBPiPManagerTest_describe', () => {
    setControlGroupsControlStatusTest_func();
    setControlGroupsControlEnableTest_func();
    getControlGroupsTest_func();
    getControlGroupsTest02_func();
    isDefaultControlVisibleTest01_func();
    isDefaultControlVisibleTest02_func();
    isDefaultControlVisibleTest03_func();
  });
}

function setControlGroupsControlStatusTest_func() {
  it('setControlGroupsControlStatus_it', Level.LEVEL0, () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('setControlGroupsControlStatusTest_bundle',
      'setControlGroupsControlStatusTest_module', 'setControlGroupsControlStatusTest_ability');
    let sceneSession: sceneSessionManager.SceneSession =
      SCBSceneSessionManager.getInstance().requestSceneSession(sceneInfo);
    let controlType: sceneSessionManager.PiPControlType = sceneSessionManager.PiPControlType.VIDEO_PLAY_PAUSE;
    let status: sceneSessionManager.PiPControlStatus = sceneSessionManager.PiPControlStatus.ENABLED;
    let mocker1: MockKit = new MockKit();
    let pipManager: SCBPiPManager = SCBPiPManager.getInstance();
    let mockAttachPiPWindowSessionFunc: Function = mocker1.mockFunc(pipManager, pipManager.attachPiPWindowSession);
    let pipSpecificSession: SCBSpecificSession | null | undefined = null;
    when(mockAttachPiPWindowSessionFunc)(null);
    pipManager.setControlGroupsControlStatus(controlType, status);
    expect(pipSpecificSession).assertNull();
    pipSpecificSession = undefined;
    when(mockAttachPiPWindowSessionFunc)(undefined);
    pipManager.setControlGroupsControlStatus(controlType, status);
    expect(pipSpecificSession).assertUndefined();
    pipSpecificSession = new SCBSpecificSession(sceneSession, ()=>{});
    when(mockAttachPiPWindowSessionFunc)(pipSpecificSession);
    pipManager.setControlGroupsControlStatus(controlType, status);
    pipManager.setControlGroupsControlStatus(controlType, status);
    expect(controlType).assertEqual(sceneSessionManager.PiPControlType.VIDEO_PLAY_PAUSE);
    mocker1.clear(mockAttachPiPWindowSessionFunc);
  });
}

function setControlGroupsControlEnableTest_func() {
  it('setControlGroupsControlEnable_it', Level.LEVEL0, () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('setControlGroupsControlStatusTest_bundle',
      'setControlGroupsControlStatusTest_module', 'setControlGroupsControlStatusTest_ability');

    let controlType: sceneSessionManager.PiPControlType = sceneSessionManager.PiPControlType.VIDEO_PLAY_PAUSE;
    let status: sceneSessionManager.PiPControlStatus = sceneSessionManager.PiPControlStatus.ENABLED;
    let mocker1: MockKit = new MockKit();
    let pipManager: SCBPiPManager = SCBPiPManager.getInstance();
    let mockAttachPiPWindowSessionFunc: Function = mocker1.mockFunc(pipManager, pipManager.attachPiPWindowSession);
    let pipSpecificSession: SCBSpecificSession | null | undefined = null;
    when(mockAttachPiPWindowSessionFunc)(null);
    pipManager.setControlGroupsControlEnable(controlType, status);
    expect(pipSpecificSession).assertNull();
    pipSpecificSession = undefined;
    when(mockAttachPiPWindowSessionFunc)(undefined);
    pipManager.setControlGroupsControlEnable(controlType, status);
    expect(pipSpecificSession).assertUndefined();
    let sceneSession: sceneSessionManager.SceneSession =
      SCBSceneSessionManager.getInstance().requestSceneSession(sceneInfo);
    pipSpecificSession = new SCBSpecificSession(sceneSession, ()=>{});
    when(mockAttachPiPWindowSessionFunc)(pipSpecificSession);
    pipManager.setControlGroupsControlEnable(controlType, status);
    pipManager.setControlGroupsControlEnable(controlType, status);
    expect(controlType).assertEqual(sceneSessionManager.PiPControlType.VIDEO_PLAY_PAUSE);
    mocker1.clear(mockAttachPiPWindowSessionFunc);
  });
}

function getControlGroupsTest_func() {
  it('getControlGroupsTest_it', Level.LEVEL0, () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('isDefaultControlVisibleTest',
      'isDefaultControlVisibleTest', 'isDefaultControlVisibleTest');
    let sceneSession: sceneSessionManager.SceneSession =
      SCBSceneSessionManager.getInstance().requestSceneSession(sceneInfo);
    let pipSpecificSession: SCBSpecificSession = new SCBSpecificSession(sceneSession, ()=>{});
    let pipManager: SCBPiPManager = SCBPiPManager.getInstance();
    let mocker1: MockKit = new MockKit();
    let mockAttachPiPWindowSessionFunc: Function = mocker1.mockFunc(pipManager, pipManager.attachPiPWindowSession);
    when(mockAttachPiPWindowSessionFunc)(pipSpecificSession);
    let array: Array<number> = pipSpecificSession.session.pipTemplateInfo.controlGroup;
    expect(pipManager.getControlGroups().toString()).assertEqual(array.toString());
    mocker1.clear(mockAttachPiPWindowSessionFunc);
  });
}

function getControlGroupsTest02_func() {
  it('getControlGroupsTest_it_02', Level.LEVEL0, () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('isDefaultControlVisibleTest',
      'isDefaultControlVisibleTest', 'isDefaultControlVisibleTest');
    let sceneSession: sceneSessionManager.SceneSession =
      SCBSceneSessionManager.getInstance().requestSceneSession(sceneInfo);
    let pipSpecificSession: SCBSpecificSession = new SCBSpecificSession(sceneSession, ()=>{});
    let pipManager: SCBPiPManager = SCBPiPManager.getInstance();
    let mocker1: MockKit = new MockKit();
    let mockAttachPiPWindowSessionFunc: Function = mocker1.mockFunc(pipManager, pipManager.attachPiPWindowSession);
    when(mockAttachPiPWindowSessionFunc)(null);
    expect(pipManager.getControlGroups().toString()).assertEqual([].toString());

    when(mockAttachPiPWindowSessionFunc)(undefined);
    expect(pipManager.getControlGroups().toString()).assertEqual([].toString());
    mocker1.clear(mockAttachPiPWindowSessionFunc);
  });
}

function isDefaultControlVisibleTest01_func() {
  it('isDefaultControlVisibleTest_it_01', Level.LEVEL0, () => {
    let pipManager: SCBPiPManager = SCBPiPManager.getInstance();
    let mocker1: MockKit = new MockKit();
    let mockTemplateTypeFunc: Function = mocker1.mockFunc(pipManager, pipManager.getTemplateType);
    let mockControlGroupFunc: Function = mocker1.mockFunc(pipManager, pipManager.getControlGroups);
    when(mockTemplateTypeFunc)(ArgumentMatchers.any).afterReturn(PipTemplate.TYPE_VIDEO_CALL);
    when(mockControlGroupFunc)(ArgumentMatchers.any).afterReturn([0, 1]);
    let result = pipManager.isDefaultControlVisible();
    expect(result).assertTrue();

    when(mockControlGroupFunc)(ArgumentMatchers.any).afterReturn([]);
    result = pipManager.isDefaultControlVisible();
    expect(result).assertFalse();
    mocker1.clear(mockTemplateTypeFunc);
    mocker1.clear(mockControlGroupFunc);
  });
}

function isDefaultControlVisibleTest02_func() {
  it('isDefaultControlVisibleTest_it_02', Level.LEVEL0, () => {
    let mocker1: MockKit = new MockKit();
    let pipManager: SCBPiPManager = SCBPiPManager.getInstance();
    let mockTemplateTypeFunc: Function = mocker1.mockFunc(pipManager, pipManager.getTemplateType);
    let mockControlGroupFunc: Function = mocker1.mockFunc(pipManager, pipManager.getControlGroups);
    when(mockTemplateTypeFunc)(ArgumentMatchers.any).afterReturn(PipTemplate.TYPE_VIDEO_MEETING);
    when(mockControlGroupFunc)(ArgumentMatchers.any).afterReturn([0, 1]);
    let result = pipManager.isDefaultControlVisible();
    expect(result).assertTrue();

    when(mockControlGroupFunc)(ArgumentMatchers.any).afterReturn([]);
    result = pipManager.isDefaultControlVisible();
    expect(result).assertFalse();
    mocker1.clear(mockTemplateTypeFunc);
    mocker1.clear(mockControlGroupFunc);
  });
}

function isDefaultControlVisibleTest03_func() {
  it('isDefaultControlVisibleTest_it_03', Level.LEVEL0, () => {
    let mocker1: MockKit = new MockKit();
    let pipManager: SCBPiPManager = SCBPiPManager.getInstance();
    let mockTemplateTypeFunc: Function = mocker1.mockFunc(pipManager, pipManager.getTemplateType);
    let mockControlGroupFunc: Function = mocker1.mockFunc(pipManager, pipManager.getControlGroups);
    when(mockTemplateTypeFunc)(ArgumentMatchers.any).afterReturn(PipTemplate.TYPE_VIDEO_PLAY);
    let result = pipManager.isDefaultControlVisible();
    expect(result).assertTrue();

    when(mockTemplateTypeFunc)(ArgumentMatchers.any).afterReturn(PipTemplate.TYPE_LIVE);
    result = pipManager.isDefaultControlVisible();
    expect(result).assertTrue();
    mocker1.clear(mockTemplateTypeFunc);
    mocker1.clear(mockControlGroupFunc);
  });
}
