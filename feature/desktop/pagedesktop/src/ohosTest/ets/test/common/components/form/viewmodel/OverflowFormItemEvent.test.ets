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
import { UIContext } from '@kit.ArkUI';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  TestType,
  Level,
  expect,
  MockKit,
  when,
  ArgumentMatchers,
} from '@ohos/hypium';
import {
  CardItemInfo,
  FormHiSysEventReporter,
  StyleConstants,
  FormCommonUtil
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import {
  FormBackboardVm,
  FormItemRelativeVm,
  FormMaskVm,
} from '../../../../../../../main/ets/default/common/components/form/viewmodel/FormItemRelativeVm';
import {
  OverflowFormVm,
  OverflowFormStatus,
  OverflowDisconnectionType
} from '../../../../../../../main/ets/default/common/components/liveform/viewmodel/OverflowFormVm';
import {
  OverflowFormItemEvent
} from '../../../../../../../main/ets/default/common/components/form/viewmodel/OverflowFormItemEvent';
import { GameCardInfo } from '@ohos/launchercommon/src/main/ets/bean/GameCardInfo';
import { FormMenuEvent } from '../../../../../../../main/ets/default/common/components/form/viewmodel/FormMenuEvent';
import { FormMenuVm } from '../../../../../../../main/ets/default/common/components/form/viewmodel/FormMenuVm';
import { CheckEmptyUtils } from '@ohos/basicutils';
import { scbEventExclusiveManager } from '@ohos/windowscene';

function createCardItemInfo(): CardItemInfo{
  let formItem: CardItemInfo = new CardItemInfo();
  formItem.area = [4, 4];
  formItem.cardId = '123';
  formItem.moduleName = 'scene_board';
  formItem.cardName = 'stackingBoxCard';
  return formItem;
}

function createGameCardInfo(): GameCardInfo{
  let gameCardInfo: GameCardInfo = new GameCardInfo();
  gameCardInfo.gameType = 'quick';
  gameCardInfo.formBindGame = 'game';
  return gameCardInfo;
}

function createOverflowFormItemEvent(): OverflowFormItemEvent{
  let formItemVm: FormItemRelativeVm = new FormItemRelativeVm();
  let formBackVm: FormBackboardVm = new FormBackboardVm();
  let formMaskVm: FormMaskVm = new FormMaskVm();
  return (new OverflowFormItemEvent(formItemVm, formBackVm, formMaskVm));
}

export function OverflowFormItemEventTest() {
  describe('OverflowFormItemEventTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('playLongPressAnimation', TestType.FUNCTION | Level.LEVEL0, () => {
      let formItemVm: FormItemRelativeVm = new FormItemRelativeVm();
      let formBackVm: FormBackboardVm = new FormBackboardVm();
      let formMaskVm: FormMaskVm = new FormMaskVm();
      let formItemEvent: OverflowFormItemEvent = new OverflowFormItemEvent(formItemVm, formBackVm, formMaskVm);

      formItemEvent.playLongPressAnimation(true, 2);
      expect(formItemVm.mDropAnimateScale).assertEqual(StyleConstants.DEFAULT_LONG_PRESS_SCALE_95);

      formItemEvent.playLongPressAnimation(true, 1);
      expect(formItemVm.mDropAnimateScale).assertEqual(StyleConstants.DEFAULT_LONG_PRESS_SCALE_90);

      formItemEvent.playLongPressAnimation(true, 4);
      expect(formItemVm.mDropAnimateScale).assertEqual(StyleConstants.DEFAULT_LONG_PRESS_SCALE_95);

      formItemEvent.playLongPressAnimation(false, 4);
      expect(formItemVm.mDropAnimateScale).assertEqual(StyleConstants.DEFAULT_1);
    });

    it('handleFormWrapperClickEvent', TestType.FUNCTION | Level.LEVEL0, () => {
      let formItemVm: FormItemRelativeVm = new FormItemRelativeVm();
      let formBackVm: FormBackboardVm = new FormBackboardVm();
      let formMaskVm: FormMaskVm = new FormMaskVm();
      let overflowFormVm: OverflowFormVm = new OverflowFormVm();
      let formItemEvent: OverflowFormItemEvent = new OverflowFormItemEvent(formItemVm, formBackVm, formMaskVm);
      let formItem: CardItemInfo = createCardItemInfo();
      formItem.gameCardInfo = createGameCardInfo();
      formItemEvent.initFormInfo(formItem, 342, 358);
      overflowFormVm.overFlowFormStatus = OverflowFormStatus.ACTIVE;
      formItemEvent.handleFormWrapperClickEvent();
      expect(formItemVm.isOverflowFormEnable).assertTrue();

      overflowFormVm.overFlowFormStatus = OverflowFormStatus.INACTIVE;
      AppStorage.setOrCreate('isNormalDesktopMode', false);
      formItemEvent.handleFormWrapperClickEvent();
      expect(formItemVm.isOverflowFormEnable).assertTrue();

      AppStorage.setOrCreate('isNormalDesktopMode', true);
      formItemEvent.handleFormWrapperClickEvent();
      expect(AppStorage.get('isNormalDesktopMode')).assertTrue();
    });

    it('handlePauseGameCardEvent', TestType.FUNCTION | Level.LEVEL0, () => {
      let formItemEvent: OverflowFormItemEvent = createOverflowFormItemEvent();
      let overflowFormVm: OverflowFormVm = new OverflowFormVm();
      let formItem: CardItemInfo = createCardItemInfo();
      formItemEvent.initFormInfo(formItem, 342, 358);

      overflowFormVm.overFlowFormStatus = OverflowFormStatus.ACTIVE;
      formItemEvent.handlePauseGameCardEvent();
      expect(overflowFormVm.overFlowFormStatus).assertEqual(OverflowFormStatus.ACTIVE);

      formItem.gameCardInfo = createGameCardInfo();
      formItemEvent.initFormInfo(formItem, 342, 358);
      formItemEvent.handlePauseGameCardEvent();
      expect(overflowFormVm.overFlowFormStatus).assertEqual(OverflowFormStatus.ACTIVE);
    });

    it('pauseOverflowForm', TestType.FUNCTION | Level.LEVEL0, () => {
      let formItemEvent: OverflowFormItemEvent = createOverflowFormItemEvent();
      let overflowFormVm: OverflowFormVm = new OverflowFormVm();
      let formItem: CardItemInfo = createCardItemInfo();
      formItemEvent.initFormInfo(formItem, 342, 358);

      overflowFormVm.overFlowFormStatus = OverflowFormStatus.ACTIVE;
      formItemEvent.pauseOverflowForm();
      expect(overflowFormVm.overFlowFormStatus).assertEqual(OverflowFormStatus.ACTIVE);
    });

    it('stopOverflowForm', TestType.FUNCTION | Level.LEVEL0, () => {
      let formItemVm: FormItemRelativeVm = new FormItemRelativeVm();
      let formBackVm: FormBackboardVm = new FormBackboardVm();
      let formMaskVm: FormMaskVm = new FormMaskVm();
      let formItemEvent: OverflowFormItemEvent= new OverflowFormItemEvent(formItemVm, formBackVm, formMaskVm);
      let formItem: CardItemInfo = createCardItemInfo();
      formItemEvent.initFormInfo(formItem, 342, 358);

      formItemVm.isOverflowFormEnable = true;
      formItemEvent.stopOverflowForm();
      expect(formItemVm.isOverflowFormEnable).assertTrue();
    });

    it('handleDisconnectGameCardEvent', TestType.FUNCTION | Level.LEVEL0, () => {
      let formItemEvent: OverflowFormItemEvent = createOverflowFormItemEvent();
      let overflowFormVm: OverflowFormVm = new OverflowFormVm();
      let formItem: CardItemInfo = createCardItemInfo();
      formItemEvent.initFormInfo(formItem, 342, 358);

      overflowFormVm.overFlowFormStatus = OverflowFormStatus.ACTIVE;
      formItemEvent.handleDisconnectGameCardEvent();
      expect(overflowFormVm.overFlowFormStatus).assertEqual(OverflowFormStatus.ACTIVE);

      formItem.gameCardInfo = createGameCardInfo();
      formItemEvent.initFormInfo(formItem, 342, 358);
      formItemEvent.handleDisconnectGameCardEvent();
      expect(overflowFormVm.overFlowFormStatus).assertEqual(OverflowFormStatus.ACTIVE);
    });

    it('recordLaunchGameCardInfo', TestType.FUNCTION | Level.LEVEL0, () => {
      let formItemEvent: OverflowFormItemEvent = createOverflowFormItemEvent();
      let formItem: CardItemInfo = createCardItemInfo();
      formItemEvent.initFormInfo(formItem, 342, 358);

      const mocker: MockKit = new MockKit();
      let called: boolean = false;
      const mockFunc: Function = mocker.mockFunc(FormHiSysEventReporter, FormHiSysEventReporter.reportLaunchGameCard);
      when(mockFunc)(ArgumentMatchers.any).afterAction(() => { called = true; });

      formItemEvent.recordLaunchGameCardInfo();
      expect(called).assertFalse();
      formItem.gameCardInfo = createGameCardInfo();
      formItemEvent.initFormInfo(formItem, 342, 358);
      formItemEvent.getOverFlowFormActiveTime();
      formItemEvent.recordLaunchGameCardInfo();
      expect(called).assertTrue();

      mocker.clear(FormHiSysEventReporter);
      mocker.clearAll();
    });

    it('getOverFlowFormResumeTime', TestType.FUNCTION | Level.LEVEL0, () => {
      let formItemEvent: OverflowFormItemEvent = createOverflowFormItemEvent();
      let formItem: CardItemInfo = createCardItemInfo();
      formItemEvent.initFormInfo(formItem, 342, 358);

      const mocker: MockKit = new MockKit();
      let called: boolean = false;
      const mockFunc: Function = mocker.mockFunc(FormHiSysEventReporter, FormHiSysEventReporter.reportResumeGameCard);
      when(mockFunc)(ArgumentMatchers.any).afterAction(() => { called = true; });

      formItemEvent.getOverFlowFormResumeTime();
      expect(called).assertFalse();

      formItem.gameCardInfo = createGameCardInfo();
      formItemEvent.initFormInfo(formItem, 342, 358);
      formItemEvent.getOverFlowFormResumeTime();
      expect(called).assertTrue();

      mocker.clear(FormHiSysEventReporter);
      mocker.clearAll();
    });

    it('test_handleFormWrapperClickEvent_1', 0, () => {
      const uIContext: UIContext = {} as UIContext;
      const overflowFormItemEvent: OverflowFormItemEvent = createOverflowFormItemEvent();
      const mOverflowFormVm: OverflowFormVm = new OverflowFormVm();
      mOverflowFormVm.overFlowFormStatus = OverflowFormStatus.PAUSE;
      overflowFormItemEvent.updateOverflowFormConfig(mOverflowFormVm, '', uIContext, '', '');
      overflowFormItemEvent.handleFormWrapperClickEvent();
      mOverflowFormVm.overFlowFormStatus = OverflowFormStatus.INACTIVE;
      overflowFormItemEvent.updateOverflowFormConfig(mOverflowFormVm, '', uIContext, '', '');
      AppStorage.set('isNormalDesktopMode', false);
      overflowFormItemEvent.handleFormWrapperClickEvent();
      AppStorage.set('isNormalDesktopMode', true);
      AppStorage.set('isDuringStartExitAnimation', true);
      overflowFormItemEvent.handleFormWrapperClickEvent();
      AppStorage.set('isDuringStartExitAnimation', false);
      overflowFormItemEvent.updateLongPressStatus(true);
      overflowFormItemEvent.handleFormWrapperClickEvent();
      overflowFormItemEvent.updateLongPressStatus(false);
      overflowFormItemEvent.handleFormWrapperClickEvent();
      expect((overflowFormItemEvent as object)['mFormItemVm']['isOverflowFormEnable']).assertEqual(true);
    });

    it('test_handleLongPressGestureAction_1', 0, () => {
      const uIContext: UIContext = {} as UIContext;
      const overflowFormItemEvent: OverflowFormItemEvent = createOverflowFormItemEvent();
      overflowFormItemEvent.handleLongPressGestureAction();
      const mOverflowFormVm: OverflowFormVm = new OverflowFormVm();
      mOverflowFormVm.overFlowFormStatus = OverflowFormStatus.ACTIVE;
      overflowFormItemEvent.updateOverflowFormConfig(mOverflowFormVm, '', uIContext, '', '');
      overflowFormItemEvent.handleLongPressGestureAction();
      expect((overflowFormItemEvent as object)['isBaseFormInLongPress']).assertTrue();
    });

    it('test_handleLongPressGestureActionEnd_1', 0, () => {
      const uIContext: UIContext = {} as UIContext;
      const overflowFormItemEvent: OverflowFormItemEvent = createOverflowFormItemEvent();
      overflowFormItemEvent.handleLongPressGestureActionEnd();
      overflowFormItemEvent.handleLongPressGestureAction();
      overflowFormItemEvent.handleLongPressGestureActionEnd();
      const mOverflowFormVm: OverflowFormVm = new OverflowFormVm();
      mOverflowFormVm.overFlowFormStatus = OverflowFormStatus.ACTIVE;
      overflowFormItemEvent.updateOverflowFormConfig(mOverflowFormVm, '', uIContext, '', '');
      overflowFormItemEvent.handleLongPressGestureActionEnd();
      expect((overflowFormItemEvent as object)['isBaseFormInLongPress']).assertFalse();
    });

    it('test_handleLongPressVibration_1', 0, () => {
      const uIContext: UIContext = {} as UIContext;
      const formMenuVm: FormMenuVm = new FormMenuVm();
      const formMenuEvent: FormMenuEvent = new FormMenuEvent(formMenuVm);
      const overflowFormItemEvent: OverflowFormItemEvent = createOverflowFormItemEvent();
      const mOverflowFormVm: OverflowFormVm = new OverflowFormVm();
      mOverflowFormVm.overFlowFormStatus = OverflowFormStatus.ACTIVE;
      overflowFormItemEvent.updateOverflowFormConfig(mOverflowFormVm, '', uIContext, '', '');
      overflowFormItemEvent.handleLongPressVibration(formMenuEvent);
      expect((overflowFormItemEvent as object)['mOverflowFormVm']['overFlowFormStatus'])
        .assertEqual(OverflowFormStatus.ACTIVE);
    });

    it('test_playLongPressAnimation_1', 0, (done: Function) => {
      const uIContext: UIContext = {} as UIContext;
      const overflowFormItemEvent: OverflowFormItemEvent = createOverflowFormItemEvent();
      const mOverflowFormVm: OverflowFormVm = new OverflowFormVm();
      mOverflowFormVm.overFlowFormStatus = OverflowFormStatus.ACTIVE;
      overflowFormItemEvent.updateOverflowFormConfig(mOverflowFormVm, '', uIContext, '', '');
      overflowFormItemEvent.playLongPressAnimation(true, 1, 1);
      expect((overflowFormItemEvent as object)['mOverflowFormVm']['overFlowFormStatus'])
        .assertEqual(OverflowFormStatus.ACTIVE);
      done()
    });

    it('test_handleLongPressVibrationEnd_1', 0, (done: Function) => {
      const uIContext: UIContext = {} as UIContext;
      const overflowFormItemEvent: OverflowFormItemEvent = createOverflowFormItemEvent();
      overflowFormItemEvent.handleLongPressVibrationEnd();
      const mOverflowFormVm: OverflowFormVm = new OverflowFormVm();
      mOverflowFormVm.overFlowFormStatus = OverflowFormStatus.ACTIVE;
      overflowFormItemEvent.updateOverflowFormConfig(mOverflowFormVm, '', uIContext, '', '');
      overflowFormItemEvent.handleLongPressVibrationEnd();
      expect((overflowFormItemEvent as object)['mOverflowFormVm']['overFlowFormStatus'])
        .assertEqual(OverflowFormStatus.ACTIVE);
      done();
    });

    it('test_onGestureJudgeBegin_1', 0, (done: Function) => {
      const fingerInfo: FingerInfo = {
        id: 1,
        globalX: 1,
        globalY: 1,
        localX: 1,
        localY: 1,
        displayX: 1,
        displayY: 1
      };
      const gestureInfo: GestureInfo = {
        type: 7,
        isSystemGesture: false
      };
      const baseGestureEvent: BaseGestureEvent = {
        fingerList: [fingerInfo]
      } as BaseGestureEvent;
      const overflowFormItemEvent: OverflowFormItemEvent = createOverflowFormItemEvent();
      expect(overflowFormItemEvent.onGestureJudgeBegin(gestureInfo, baseGestureEvent)).assertEqual(0);
      done()
    });

    it('test_onGestureJudgeBegin_2', 0, (done: Function) => {
      const uIContext: UIContext = {} as UIContext;
      const fingerInfo: FingerInfo = {
        id: 1,
        globalX: 1,
        globalY: 1,
        localX: 1,
        localY: 1,
        displayX: 1,
        displayY: 1
      };
      const gestureInfo: GestureInfo = {
        type: 6,
        isSystemGesture: false
      };
      const baseGestureEvent: BaseGestureEvent = {
        fingerList: [fingerInfo]
      } as BaseGestureEvent;
      const overflowFormItemEvent: OverflowFormItemEvent = createOverflowFormItemEvent();
      const mOverflowFormVm: OverflowFormVm = new OverflowFormVm();
      mOverflowFormVm.overFlowFormStatus = OverflowFormStatus.ACTIVE;
      overflowFormItemEvent.updateOverflowFormConfig(mOverflowFormVm, '', uIContext, '', '');
      expect(overflowFormItemEvent.onGestureJudgeBegin(gestureInfo, baseGestureEvent)).assertEqual(1);
      mOverflowFormVm.overFlowFormStatus = OverflowFormStatus.PAUSE;
      overflowFormItemEvent.updateOverflowFormConfig(mOverflowFormVm, '', uIContext, '', '');
      overflowFormItemEvent.onGestureJudgeBegin(gestureInfo, baseGestureEvent)
      expect((overflowFormItemEvent as object)['mOverflowFormVm']['overFlowFormStatus'])
        .assertEqual(OverflowFormStatus.PAUSE);
      done();
    });

    it('test_stopOverflowForm_1', 0, (done: Function) => {
      const uIContext: UIContext = {} as UIContext;
      const overflowFormItemEvent: OverflowFormItemEvent = createOverflowFormItemEvent();
      const mOverflowFormVm: OverflowFormVm = new OverflowFormVm();
      overflowFormItemEvent.updateOverflowFormConfig(mOverflowFormVm, '', uIContext, '', '');
      overflowFormItemEvent.stopOverflowForm();
      expect((overflowFormItemEvent as object)['mOverflowFormVm']['overFlowFormStatus'])
        .assertEqual(OverflowFormStatus.INACTIVE);
      done();
    });

    it('test_pauseOverflowForm_1', 0, (done: Function) => {
      const uIContext: UIContext = {} as UIContext;
      const overflowFormItemEvent: OverflowFormItemEvent = createOverflowFormItemEvent();
      const mOverflowFormVm: OverflowFormVm = new OverflowFormVm();
      overflowFormItemEvent.updateOverflowFormConfig(mOverflowFormVm, '', uIContext, '', '');
      overflowFormItemEvent.pauseOverflowForm();
      expect((overflowFormItemEvent as object)['mOverflowFormVm']['overflowPauseVisibilityStatus'])
        .assertEqual(Visibility.Visible);
      done();
    });

    it('test_startOverflowForm_1', 0, (done: Function) => {
      const uIContext: UIContext = {} as UIContext;
      const overflowFormItemEvent: OverflowFormItemEvent = createOverflowFormItemEvent();
      overflowFormItemEvent.startOverflowForm();
      const mOverflowFormVm: OverflowFormVm = new OverflowFormVm();
      overflowFormItemEvent.updateOverflowFormConfig(mOverflowFormVm, '', uIContext, '', '');
      overflowFormItemEvent.startOverflowForm();
      expect((overflowFormItemEvent as object)['mOverflowFormVm']['overFlowFormVisibilityStatus'])
        .assertEqual(Visibility.Visible);
      done();
    });

    it('test_updateOverflowFormEnableStatus_1', 0, (done: Function) => {
      const overflowFormItemEvent: OverflowFormItemEvent = createOverflowFormItemEvent();
      overflowFormItemEvent.updateOverflowFormEnableStatus(true);
      expect((overflowFormItemEvent as object)['mFormItemVm']['isOverflowFormEnable']).assertEqual(true);
      done();
    });

    it('test_updateControlButtonInRenderGroupStatus_1', 0, (done: Function) => {
      const uIContext: UIContext = {} as UIContext;
      const overflowFormItemEvent: OverflowFormItemEvent = createOverflowFormItemEvent();
      overflowFormItemEvent.updateControlButtonInRenderGroupStatus(true);
      const mOverflowFormVm: OverflowFormVm = new OverflowFormVm();
      overflowFormItemEvent.updateOverflowFormConfig(mOverflowFormVm, '', uIContext, '', '');
      overflowFormItemEvent.updateControlButtonInRenderGroupStatus(true);
      expect((overflowFormItemEvent as object)['mOverflowFormVm']['isControlButtonInRenderGroup']).assertEqual(true);
      done();
    });

    it('test_recordLaunchGameCardInfo_1', 0, (done: Function) => {
      const uIContext: UIContext = {} as UIContext;
      const overflowFormItemEvent: OverflowFormItemEvent = createOverflowFormItemEvent();
      const mOverflowFormVm: OverflowFormVm = new OverflowFormVm();
      overflowFormItemEvent.updateOverflowFormConfig(mOverflowFormVm, '', uIContext, '', '');
      (overflowFormItemEvent as object)['overFlowFormLastPauseTime'] = 10;
      overflowFormItemEvent.recordLaunchGameCardInfo();
      expect((overflowFormItemEvent as object)['overFlowFormPauseDuration']).assertEqual(0);
      done();
    });

    it('test_onTouchEventHandler_1', 0, (done: Function) => {
      try {
        const touchEvent: TouchEvent = {} as TouchEvent;
        const overflowFormItemEvent: OverflowFormItemEvent = createOverflowFormItemEvent();
        const mocker: MockKit = new MockKit();
        const mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        overflowFormItemEvent.onTouchEventHandler(touchEvent, '1', true);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        const mockFunc1: Function = mocker.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
        overflowFormItemEvent.onTouchEventHandler(touchEvent, '1', true);
        expect((overflowFormItemEvent as object)['isUpdateSnapshotFailed']).assertEqual(false);
        mocker.clear(CheckEmptyUtils);
        mocker.clear(scbEventExclusiveManager);
        mocker.clearAll();
        done();
      } catch (err) {
        expect(JSON.stringify(err)).not().assertNull();
      }
    });

    it('test_handlerDragEnd_1', 0, (done: Function) => {
      const uIContext: UIContext = {} as UIContext;
      const overflowFormItemEvent: OverflowFormItemEvent = createOverflowFormItemEvent();
      const mOverflowFormVm: OverflowFormVm = new OverflowFormVm();
      mOverflowFormVm.overFlowFormStatus = OverflowFormStatus.ACTIVE;
      overflowFormItemEvent.updateOverflowFormConfig(mOverflowFormVm, '', uIContext, '', '');
      overflowFormItemEvent.handlerDragEnd();
      expect((overflowFormItemEvent as object)['mOverflowFormVm']['overFlowFormStatus']).assertEqual(OverflowFormStatus.ACTIVE);
      done();
    });

    it('test_requestFocusWhenStart_1', 0, (done: Function) => {
      const overflowFormItemEvent: OverflowFormItemEvent = createOverflowFormItemEvent();
      overflowFormItemEvent.requestFocusWhenStart();
      expect(overflowFormItemEvent).not().assertNull();
      done();
    });

    it('test_setBaseFormVisibility_1', 0, (done: Function) => {
      const uIContext: UIContext = {} as UIContext;
      const overflowFormItemEvent: OverflowFormItemEvent = createOverflowFormItemEvent();
      overflowFormItemEvent.setBaseFormVisibility();
      const mOverflowFormVm: OverflowFormVm = new OverflowFormVm();
      mOverflowFormVm.overFlowMaskVisibilityStatus = Visibility.Hidden;
      overflowFormItemEvent.updateOverflowFormConfig(mOverflowFormVm, '', uIContext, '', '');
      overflowFormItemEvent.setBaseFormVisibility();
      expect((overflowFormItemEvent as object)['mFormItemVm']['formVisibilityStatus']).assertEqual(Visibility.Hidden);
      done();
    });

    it('test_updateLongPressStatus_1', 0, (done: Function) => {
      const uIContext: UIContext = {} as UIContext;
      const overflowFormItemEvent: OverflowFormItemEvent = createOverflowFormItemEvent();
      overflowFormItemEvent.updateLongPressStatus(true);
      const mOverflowFormVm: OverflowFormVm = new OverflowFormVm();
      mOverflowFormVm.isInLongPress = true;
      overflowFormItemEvent.updateOverflowFormConfig(mOverflowFormVm, '', uIContext, '', '');
      overflowFormItemEvent.updateLongPressStatus(true);
      expect((overflowFormItemEvent as object)['mOverflowFormVm']['isInLongPress']).assertEqual(true);
      done();
    });

    it('test_handlePauseGameCardEvent_1', 0, (done: Function) => {
      const uIContext: UIContext = {} as UIContext;
      const overflowFormItemEvent: OverflowFormItemEvent = createOverflowFormItemEvent();
      overflowFormItemEvent.handlePauseGameCardEvent();
      const mOverflowFormVm: OverflowFormVm = new OverflowFormVm();
      mOverflowFormVm.overFlowMaskVisibilityStatus = Visibility.Hidden;
      overflowFormItemEvent.updateOverflowFormConfig(mOverflowFormVm, '', uIContext, '', '');
      overflowFormItemEvent.handlePauseGameCardEvent();
      expect((overflowFormItemEvent as object)['mOverflowFormVm']['isControlButtonInRenderGroup']).assertEqual(true);
      done();
    });

    it('test_handleLongPressVibrationCancel_1', 0, (done: Function) => {
      const overflowFormItemEvent: OverflowFormItemEvent = createOverflowFormItemEvent();
      overflowFormItemEvent.handleLongPressVibrationCancel();
      const uIContext: UIContext = {} as UIContext;
      const mOverflowFormVm: OverflowFormVm = new OverflowFormVm();
      mOverflowFormVm.overFlowFormStatus = OverflowFormStatus.ACTIVE;
      overflowFormItemEvent.updateOverflowFormConfig(mOverflowFormVm, '', uIContext, '', '');
      overflowFormItemEvent.handleLongPressVibrationCancel();
      expect((overflowFormItemEvent as object)['isBaseFormInLongPress']).assertEqual(false);
      done();
    });

    it('test_handleLongPressGestureActionCancel_1', 0, (done: Function) => {
      const overflowFormItemEvent: OverflowFormItemEvent = createOverflowFormItemEvent();
      overflowFormItemEvent.handleLongPressGestureActionCancel();
      const uIContext: UIContext = {} as UIContext;
      const mOverflowFormVm: OverflowFormVm = new OverflowFormVm();
      mOverflowFormVm.overFlowFormStatus = OverflowFormStatus.ACTIVE;
      overflowFormItemEvent.updateOverflowFormConfig(mOverflowFormVm, '', uIContext, '', '');
      overflowFormItemEvent.handleLongPressGestureActionCancel();
      expect((overflowFormItemEvent as object)['isBaseFormInLongPress']).assertEqual(false);
      done();
    });

    it('test_loadQuickGameExtWant_1', 0, (done: Function) => {
      const overflowFormItemEvent: OverflowFormItemEvent = createOverflowFormItemEvent();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(FormCommonUtil, FormCommonUtil.getFormComponentId);
      when(mockFunc)(ArgumentMatchers.any).afterReturn('1');
      overflowFormItemEvent.loadQuickGameExtWant(10, 10, 10);
      const uIContext: UIContext = {} as UIContext;
      const mOverflowFormVm: OverflowFormVm = new OverflowFormVm();
      overflowFormItemEvent.updateOverflowFormConfig(mOverflowFormVm, '', uIContext, '', '');
      overflowFormItemEvent.loadQuickGameExtWant(10, 10, 10);
      expect((overflowFormItemEvent as object)['isBaseFormInLongPress']).assertEqual(false);
      mocker.clear(FormCommonUtil);
      mocker.clearAll();
      done();
    });

    it('test_requestFocusWhenStart_1', 0, (done: Function) => {
      const overflowFormItemEvent: OverflowFormItemEvent = createOverflowFormItemEvent();
      overflowFormItemEvent.requestFocusWhenStart();
      expect((overflowFormItemEvent as object)['isBaseFormInLongPress']).assertEqual(false);
      done();
    });

    it('test_handleDisconnectGameCardEvent_1', 0, (done: Function) => {
      const overflowFormItemEvent: OverflowFormItemEvent = createOverflowFormItemEvent();
      const uIContext: UIContext = {} as UIContext;
      const mOverflowFormVm: OverflowFormVm = new OverflowFormVm();
      mOverflowFormVm.overFlowFormDisconnType = OverflowDisconnectionType.ABNORMAL_EXIT;
      overflowFormItemEvent.updateOverflowFormConfig(mOverflowFormVm, '', uIContext, '', '');
      overflowFormItemEvent.handlePauseGameCardEvent();
      mOverflowFormVm.overFlowFormDisconnType = OverflowDisconnectionType.PROVIDER_QUIT;
      overflowFormItemEvent.updateOverflowFormConfig(mOverflowFormVm, '', uIContext, '', '');
      overflowFormItemEvent.handlePauseGameCardEvent();
      expect((overflowFormItemEvent as object)['isBaseFormInLongPress']).assertEqual(false);
      done();
    });

    it('test_isAliveOverflowForm_1', 0, (done: Function) => {
      const overflowFormItemEvent: ESObject = createOverflowFormItemEvent();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(overflowFormItemEvent, overflowFormItemEvent['isActiveOverflowForm']);
      const mockFunc2: Function = mocker.mockFunc(overflowFormItemEvent, overflowFormItemEvent['isPauseOverflowForm']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      expect(overflowFormItemEvent['isAliveOverflowForm']?.()).assertEqual(true);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      expect(overflowFormItemEvent['isAliveOverflowForm']?.()).assertEqual(true);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect(overflowFormItemEvent['isAliveOverflowForm']?.()).assertEqual(false);
      mocker.clear(overflowFormItemEvent);
      mocker.clearAll();
      done();
    });

    it('test_isPauseOverflowForm_1', 0, (done: Function) => {
      const overflowFormItemEvent: ESObject = createOverflowFormItemEvent();
      expect(overflowFormItemEvent['isPauseOverflowForm']?.()).assertEqual(false);
      const uIContext: UIContext = {} as UIContext;
      const mOverflowFormVm: OverflowFormVm = new OverflowFormVm();
      mOverflowFormVm.overFlowFormStatus = OverflowFormStatus.PAUSE;
      overflowFormItemEvent.updateOverflowFormConfig(mOverflowFormVm, '', uIContext, '', '');
      expect(overflowFormItemEvent['isPauseOverflowForm']?.()).assertEqual(true);
      mOverflowFormVm.overFlowFormStatus = OverflowFormStatus.ACTIVE;
      overflowFormItemEvent.updateOverflowFormConfig(mOverflowFormVm, '', uIContext, '', '');
      expect(overflowFormItemEvent['isPauseOverflowForm']?.()).assertEqual(false);
      done();
    });

    it('OverflowFormItemEventTest_handleTouchEvent_002', TestType.FUNCTION | Level.LEVEL0, () => {
      let touchEvent: TouchEvent = {
        target: { area: { width: 0, height: 0, position: { x: 0, y: 0 }, globalPosition: { x: 0, y: 0 } } },
        timestamp: 0, source: 0, pressure: 0, tiltX: 0, tiltY: 0, sourceTool: 0, type: TouchType.Down,
        touches: [{ id: 0, type: 0, displayX: 0, displayY: 0, windowX: 0, windowY: 0, screenX: 0, screenY: 0, x: 0, y: 0 }],
        changedTouches: [{ id: 0, type: 0, displayX: 0, displayY: 0, windowX: 0, windowY: 0, screenX: 0, screenY: 0, x: 0, y: 0 }],
        stopPropagation: (): void => {
          throw new Error('Function not implemented.');
        },
        getHistoricalPoints: (): HistoricalPoint[] => {
          throw new Error('Function not implemented.');
        },
        preventDefault: () => { }
      }
      let instance: OverflowFormItemEvent = createOverflowFormItemEvent();
      instance.handleTouchEvent(touchEvent, 'test', true);
      expect(instance).not().assertNull();
    });

    it('OverflowFormItemEventTest_handleFormWrapperClickEvent_003', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowFormItemEvent = createOverflowFormItemEvent();
      let overflowFormVm: OverflowFormVm = new OverflowFormVm();
      overflowFormVm.overFlowFormStatus = OverflowFormStatus.PAUSE;
      (instance as object)['mOverflowFormVm'] = overflowFormVm;
      instance.handleFormWrapperClickEvent();
      expect(instance).not().assertNull();

      ((instance as object)['mOverflowFormVm'] as OverflowFormVm).overFlowFormStatus = OverflowFormStatus.INACTIVE;
      AppStorage.setOrCreate('isNormalDesktopMode', false);
      instance.handleFormWrapperClickEvent();
      expect(instance).not().assertNull();

      ((instance as object)['mOverflowFormVm'] as OverflowFormVm).overFlowFormStatus = OverflowFormStatus.INACTIVE;
      AppStorage.setOrCreate('isNormalDesktopMode', true);
      AppStorage.setOrCreate('isDuringStartExitAnimation', true);
      instance.handleFormWrapperClickEvent();
      expect(instance).not().assertNull();

      ((instance as object)['mOverflowFormVm'] as OverflowFormVm).overFlowFormStatus = OverflowFormStatus.INACTIVE;
      AppStorage.setOrCreate('isNormalDesktopMode', true);
      AppStorage.setOrCreate('isDuringStartExitAnimation', false);
      (instance as object)['isBaseFormInLongPress'] = true;
      instance.handleFormWrapperClickEvent();
      expect(instance).not().assertNull();

      ((instance as object)['mOverflowFormVm'] as OverflowFormVm).overFlowFormStatus = OverflowFormStatus.INACTIVE;
      AppStorage.setOrCreate('isNormalDesktopMode', true);
      AppStorage.setOrCreate('isDuringStartExitAnimation', false);
      (instance as object)['isBaseFormInLongPress'] = false;
      instance.handleFormWrapperClickEvent();
      expect(instance).not().assertNull();
    });

    it('OverflowFormItemEventTest_handleLongPressGestureAction_004', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowFormItemEvent = createOverflowFormItemEvent();
      let overflowFormVm: OverflowFormVm = new OverflowFormVm();
      overflowFormVm.overFlowFormStatus = OverflowFormStatus.ACTIVE;
      (instance as object)['mOverflowFormVm'] = overflowFormVm;
      instance.handleLongPressGestureAction();
      expect(instance).not().assertNull();

      ((instance as object)['mOverflowFormVm'] as OverflowFormVm).overFlowFormStatus = OverflowFormStatus.INACTIVE;
      instance.handleLongPressGestureAction();
      expect(instance).not().assertNull();
    });

    it('OverflowFormItemEventTest_handleLongPressGestureAction_005', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowFormItemEvent = createOverflowFormItemEvent();
      let overflowFormVm: OverflowFormVm = new OverflowFormVm();
      overflowFormVm.overFlowFormStatus = OverflowFormStatus.ACTIVE;
      (instance as object)['mOverflowFormVm'] = overflowFormVm;
      instance.handleLongPressGestureActionEnd();
      expect(instance).not().assertNull();

      ((instance as object)['mOverflowFormVm'] as OverflowFormVm).overFlowFormStatus = OverflowFormStatus.INACTIVE;
      instance.handleLongPressGestureActionEnd();
      expect(instance).not().assertNull();

      ((instance as object)['mOverflowFormVm'] as OverflowFormVm).overFlowFormStatus = OverflowFormStatus.INACTIVE;
      (instance as object)['isBaseFormInLongPress'] = true;
      instance.handleLongPressGestureActionEnd();
      expect(instance).not().assertNull();
    });

    it('OverflowFormItemEventTest_handleLongPressVibration_006', TestType.FUNCTION | Level.LEVEL0, () => {
      let event: FormMenuEvent = new FormMenuEvent(new FormMenuVm());
      let instance: OverflowFormItemEvent = createOverflowFormItemEvent();
      let overflowFormVm: OverflowFormVm = new OverflowFormVm();
      overflowFormVm.overFlowFormStatus = OverflowFormStatus.ACTIVE;
      (instance as object)['mOverflowFormVm'] = overflowFormVm;
      instance.handleLongPressVibration(event);
      expect(instance).not().assertNull();

      ((instance as object)['mOverflowFormVm'] as OverflowFormVm).overFlowFormStatus = OverflowFormStatus.INACTIVE;
      instance.handleLongPressVibration(event);
      expect(instance).not().assertNull();
    });

    it('OverflowFormItemEventTest_handleLongPressVibration_007', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowFormItemEvent = createOverflowFormItemEvent();
      let overflowFormVm: OverflowFormVm = new OverflowFormVm();
      overflowFormVm.overFlowFormStatus = OverflowFormStatus.ACTIVE;
      (instance as object)['mOverflowFormVm'] = overflowFormVm;
      instance.playLongPressAnimation(true, 2);
      expect(instance).not().assertNull();

      ((instance as object)['mOverflowFormVm'] as OverflowFormVm).overFlowFormStatus = OverflowFormStatus.INACTIVE;
      instance.playLongPressAnimation(false, 4);
      expect(instance).not().assertNull();
    });

    it('OverflowFormItemEventTest_handleMenuDisappear_008', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowFormItemEvent = createOverflowFormItemEvent();
      instance.handleMenuDisappear();
      expect(instance).not().assertNull();
    });

    it('OverflowFormItemEventTest_handleLongPressVibrationEnd_009', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowFormItemEvent = createOverflowFormItemEvent();
      let overflowFormVm: OverflowFormVm = new OverflowFormVm();
      overflowFormVm.overFlowFormStatus = OverflowFormStatus.ACTIVE;
      (instance as object)['mOverflowFormVm'] = overflowFormVm;
      instance.handleLongPressVibrationEnd();
      expect(instance).not().assertNull();

      ((instance as object)['mOverflowFormVm'] as OverflowFormVm).overFlowFormStatus = OverflowFormStatus.INACTIVE;
      instance.handleLongPressVibrationEnd();
      expect(instance).not().assertNull();
    });

    it('OverflowFormItemEventTest_onGestureJudgeBegin_010', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowFormItemEvent = createOverflowFormItemEvent();
      let overflowFormVm: OverflowFormVm = new OverflowFormVm();
      overflowFormVm.overFlowFormStatus = OverflowFormStatus.ACTIVE;
      (instance as object)['mOverflowFormVm'] = overflowFormVm;
      const gestureInfo: GestureInfo = { type: GestureControl.GestureType.DRAG, isSystemGesture: true };
      const gestureEvent: BaseGestureEvent = {
        fingerList: [], target: { area: { width: 0, height: 0, position: {}, globalPosition: {} } }, timestamp: 0, source: SourceType.Unknown, pressure: 0, tiltX: 0, tiltY: 0, sourceTool: SourceTool.Unknown
      };
      instance.onGestureJudgeBegin(gestureInfo, gestureEvent);
      expect(instance).not().assertNull();

      ((instance as object)['mOverflowFormVm'] as OverflowFormVm).overFlowFormStatus = OverflowFormStatus.INACTIVE;
      instance.onGestureJudgeBegin(gestureInfo, gestureEvent);
      expect(instance).not().assertNull();
    });

    it('OverflowFormItemEventTest_onGestureJudgeBegin_011', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowFormItemEvent = createOverflowFormItemEvent();
      let overflowFormVm: OverflowFormVm = new OverflowFormVm();
      overflowFormVm.overFlowFormStatus = OverflowFormStatus.ACTIVE;
      (instance as object)['mOverflowFormVm'] = overflowFormVm;
      const gestureInfo: GestureInfo = { type: GestureControl.GestureType.CLICK, isSystemGesture: true };
      const gestureEvent: BaseGestureEvent = {
        fingerList: [], target: { area: { width: 0, height: 0, position: {}, globalPosition: {} } }, timestamp: 0, source: SourceType.Unknown, pressure: 0, tiltX: 0, tiltY: 0, sourceTool: SourceTool.Unknown
      };
      instance.onGestureJudgeBegin(gestureInfo, gestureEvent);
      expect(instance).not().assertNull();
    });

    it('OverflowFormItemEventTest_stopOverflowForm_012', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowFormItemEvent = createOverflowFormItemEvent();
      (instance as object)['mOverflowFormVm'] = new OverflowFormVm();
      instance.stopOverflowForm();
      expect(instance).not().assertNull();

      (instance as object)['mOverflowFormVm'] = null;
      instance.stopOverflowForm();
      expect(instance).not().assertNull();
    });

    it('OverflowFormItemEventTest_pauseOverflowForm_013', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowFormItemEvent = createOverflowFormItemEvent();
      (instance as object)['mOverflowFormVm'] = new OverflowFormVm();
      instance.pauseOverflowForm();
      expect(instance).not().assertNull();

      (instance as object)['mOverflowFormVm'] = null;
      instance.pauseOverflowForm();
      expect(instance).not().assertNull();
    });

    it('OverflowFormItemEventTest_startOverflowForm_014', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowFormItemEvent = createOverflowFormItemEvent();
      (instance as object)['mOverflowFormVm'] = new OverflowFormVm();
      instance.startOverflowForm();
      expect(instance).not().assertNull();

      (instance as object)['mOverflowFormVm'] = null;
      instance.startOverflowForm();
      expect(instance).not().assertNull();
    });

    it('OverflowFormItemEventTest_updateOverflowFormEnableStatus_015', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowFormItemEvent = createOverflowFormItemEvent();
      instance.updateOverflowFormEnableStatus(true);
      expect(instance).not().assertNull();

      (instance as object)['mFormItemVm'] = null;
      instance.updateOverflowFormEnableStatus(false);
      expect(instance).not().assertNull();
    });

    it('OverflowFormItemEventTest_updateControlButtonInRenderGroupStatus_016', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowFormItemEvent = createOverflowFormItemEvent();
      (instance as object)['mOverflowFormVm'] = new OverflowFormVm();
      instance.updateControlButtonInRenderGroupStatus(true);
      expect(instance).not().assertNull();

      (instance as object)['mOverflowFormVm'] = null;
      instance.updateControlButtonInRenderGroupStatus(false);
      expect(instance).not().assertNull();
    });

    it('OverflowFormItemEventTest_updateOverflowFormConfig_017', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowFormItemEvent = createOverflowFormItemEvent();
      instance.updateOverflowFormConfig(new OverflowFormVm(), 'test', new UIContext(), 'test', 'test');
      expect(instance).not().assertNull();
    });

    it('OverflowFormItemEventTest_recordLaunchGameCardInfo_018', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowFormItemEvent = createOverflowFormItemEvent();
      (instance as object)['overFlowFormLastPauseTime'] = 1;
      instance.recordLaunchGameCardInfo();
      expect(instance).not().assertNull();
    });

    it('OverflowFormItemEventTest_onTouchEventHandler_019', TestType.FUNCTION | Level.LEVEL0, () => {
      let touchEvent: TouchEvent = {
        target: { area: { width: 0, height: 0, position: { x: 0, y: 0 }, globalPosition: { x: 0, y: 0 } } },
        timestamp: 0, source: 0, pressure: 0, tiltX: 0, tiltY: 0, sourceTool: 0, type: TouchType.Down,
        touches: [{ id: 0, type: 0, displayX: 0, displayY: 0, windowX: 0, windowY: 0, screenX: 0, screenY: 0, x: 0, y: 0 }],
        changedTouches: [{ id: 0, type: 0, displayX: 0, displayY: 0, windowX: 0, windowY: 0, screenX: 0, screenY: 0, x: 0, y: 0 }],
        stopPropagation: (): void => {
          throw new Error('Function not implemented.');
        },
        getHistoricalPoints: (): HistoricalPoint[] => {
          throw new Error('Function not implemented.');
        },
        preventDefault: () => {
        }
      }
      let instance: OverflowFormItemEvent = createOverflowFormItemEvent();
      instance.onTouchEventHandler(touchEvent, 'test', true);
      expect(instance).not().assertNull();
    });

    it('OverflowFormItemEventTest_handlerDragEnd_020', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowFormItemEvent = createOverflowFormItemEvent();
      let overflowFormVm: OverflowFormVm = new OverflowFormVm();
      overflowFormVm.overFlowFormStatus = OverflowFormStatus.ACTIVE;
      (instance as object)['mOverflowFormVm'] = overflowFormVm;
      instance.handlerDragEnd();
      expect(instance).not().assertNull();

      ((instance as object)['mOverflowFormVm'] as OverflowFormVm).overFlowFormStatus = OverflowFormStatus.INACTIVE;
      instance.handlerDragEnd();
      expect(instance).not().assertNull();
    });

    it('OverflowFormItemEventTest_requestFocusWhenStart_021', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowFormItemEvent = createOverflowFormItemEvent();
      instance.requestFocusWhenStart();
      expect(instance).not().assertNull();
    });

    it('OverflowFormItemEventTest_setBaseFormVisibility_022', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowFormItemEvent = createOverflowFormItemEvent();
      instance.setBaseFormVisibility();
      expect(instance).not().assertNull();
    });

    it('OverflowFormItemEventTest_updateLongPressStatus_023', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowFormItemEvent = createOverflowFormItemEvent();
      let overflowFormVm: OverflowFormVm = new OverflowFormVm();
      (instance as object)['mOverflowFormVm'] = overflowFormVm;
      instance.updateLongPressStatus(true);
      expect(instance).not().assertNull();

      (instance as object)['mOverflowFormVm'] = null;
      instance.updateLongPressStatus(false);
      expect(instance).not().assertNull();
    });

    it('OverflowFormItemEventTest_handlePauseGameCardEvent_024', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowFormItemEvent = createOverflowFormItemEvent();
      let overflowFormVm: OverflowFormVm = new OverflowFormVm();
      (instance as object)['mOverflowFormVm'] = overflowFormVm;
      instance.handlePauseGameCardEvent();
      expect(instance).not().assertNull();
    });

    it('OverflowFormItemEventTest_handleDisconnectGameCardEvent_025', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowFormItemEvent = createOverflowFormItemEvent();
      let overflowFormVm: OverflowFormVm = new OverflowFormVm();
      overflowFormVm.overFlowFormDisconnType = OverflowDisconnectionType.PROVIDER_QUIT;
      (instance as object)['mOverflowFormVm'] = overflowFormVm;
      (instance as object)['overFlowFormPauseTime'] = 1;
      instance.handleDisconnectGameCardEvent();
      expect(instance).not().assertNull();

      overflowFormVm.overFlowFormDisconnType = OverflowDisconnectionType.ABNORMAL_EXIT;
      (instance as object)['mOverflowFormVm'] = overflowFormVm;
      instance.handleDisconnectGameCardEvent();
      expect(instance).not().assertNull();
    });

    it('OverflowFormItemEventTest_cancelLongPressAnimation_026', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowFormItemEvent = createOverflowFormItemEvent();
      instance.cancelLongPressAnimation();
      expect(instance).not().assertNull();
    });

    it('OverflowFormItemEventTest_dragSnapshotHandler_027', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowFormItemEvent = createOverflowFormItemEvent();
      (instance as object)['dragSnapshotHandler']();
      expect(instance).not().assertNull();

      let overflowFormVm: OverflowFormVm = new OverflowFormVm();
      (instance as object)['mOverflowFormVm'] = overflowFormVm;
      (instance as object)['dragSnapshotHandler']();
      expect(instance).not().assertNull();
    });

    it('OverflowFormItemEventTest_handleLongPressVibrationCancel_028', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowFormItemEvent = createOverflowFormItemEvent();
      let overflowFormVm: OverflowFormVm = new OverflowFormVm();
      overflowFormVm.overFlowFormStatus = OverflowFormStatus.ACTIVE;
      (instance as object)['mOverflowFormVm'] = overflowFormVm;
      instance.handleLongPressVibrationCancel();
      expect(instance).not().assertNull();

      ((instance as object)['mOverflowFormVm'] as OverflowFormVm).overFlowFormStatus = OverflowFormStatus.INACTIVE;
      instance.handleLongPressVibrationCancel();
      expect(instance).not().assertNull();
    });

    it('OverflowFormItemEventTest_handleLongPressGestureActionCancel_029', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowFormItemEvent = createOverflowFormItemEvent();
      let overflowFormVm: OverflowFormVm = new OverflowFormVm();
      overflowFormVm.overFlowFormStatus = OverflowFormStatus.ACTIVE;
      (instance as object)['mOverflowFormVm'] = overflowFormVm;
      instance.handleLongPressGestureActionCancel();
      expect(instance).not().assertNull();

      ((instance as object)['mOverflowFormVm'] as OverflowFormVm).overFlowFormStatus = OverflowFormStatus.INACTIVE;
      instance.handleLongPressGestureActionCancel();
      expect(instance).not().assertNull();
    });

    it('OverflowFormItemEventTest_isAliveOverflowForm_030', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowFormItemEvent = createOverflowFormItemEvent();
      (instance as object)['isAliveOverflowForm']();
      expect(instance).not().assertNull();
    });

    it('OverflowFormItemEventTest_isActiveOverflowForm_031', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowFormItemEvent = createOverflowFormItemEvent();
      let overflowFormVm: OverflowFormVm = new OverflowFormVm();
      (instance as object)['mOverflowFormVm'] = overflowFormVm;
      (instance as object)['isActiveOverflowForm']();
      expect(instance).not().assertNull();

      (instance as object)['mOverflowFormVm'] = null;
      (instance as object)['isActiveOverflowForm']();
      expect(instance).not().assertNull();
    });

    it('OverflowFormItemEventTest_isPauseOverflowForm_032', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowFormItemEvent = createOverflowFormItemEvent();
      let overflowFormVm: OverflowFormVm = new OverflowFormVm();
      (instance as object)['mOverflowFormVm'] = overflowFormVm;
      (instance as object)['isPauseOverflowForm']();
      expect(instance).not().assertNull();

      (instance as object)['mOverflowFormVm'] = null;
      (instance as object)['isPauseOverflowForm']();
      expect(instance).not().assertNull();
    });

    it('OverflowFormItemEventTest_loadQuickGameExtWant_033', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowFormItemEvent = createOverflowFormItemEvent();
      let overflowFormVm: OverflowFormVm = new OverflowFormVm();
      (instance as object)['mOverflowFormVm'] = overflowFormVm;
      instance.loadQuickGameExtWant(1, 2, 3);
      expect(instance).not().assertNull();

      (instance as object)['mOverflowFormVm'] = null;
      instance.loadQuickGameExtWant(1, 2, 3);
      expect(instance).not().assertNull();
    });

    it('OverflowFormItemEventTest_reportLaunchGameCardEvent_034', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowFormItemEvent = createOverflowFormItemEvent();
      (instance as object)['reportLaunchGameCardEvent'](1, 2, 3);
      expect(instance).not().assertNull();
    });

    it('OverflowFormItemEventTest_reportResumeGameCardEvent_035', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowFormItemEvent = createOverflowFormItemEvent();
      (instance as object)['reportResumeGameCardEvent']();
      expect(instance).not().assertNull();
    });

    it('OverflowFormItemEventTest_reportPauseGameCardEvent_036', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowFormItemEvent = createOverflowFormItemEvent();
      (instance as object)['reportPauseGameCardEvent'](1);
      expect(instance).not().assertNull();
    });

    it('OverflowFormItemEventTest_reportDisconnectGameCardEvent_037', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowFormItemEvent = createOverflowFormItemEvent();
      (instance as object)['reportDisconnectGameCardEvent'](1, 2, 3);
      expect(instance).not().assertNull();
    });

    it('OverflowFormItemEventTest_reportDisconnectGameCardEvent_038', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowFormItemEvent = createOverflowFormItemEvent();
      let result: string = (instance as object)['getDpSize']();
      expect(result.length > 0).assertTrue();
    });

  });
}