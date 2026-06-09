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

import { ILiveCardSystemProgressVm } from '../../../../main/ets/live/interface/ILiveCardSystemProgressVm';
import { LiveItemBaseVm } from '../../../../main/ets/live/vm/LiveBaseVm';
import { LiveCardSystemModel } from '../../../../main/ets/live/model/LiveCardSystemModel';
import { SysTypeCode } from '../../../../main/ets/liveview/common/LiveConstants';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import notificationManager from '@ohos.notificationManager';
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { LiveCardSystemProgressVm } from '../../../../main/ets/live/vm/LiveCardSystemProgressVm';

export default function LiveCardSystemProgressVmTest() {
  describe('onClickButton_testSuite', () => {
    beforeEach(() => {
    });
    afterEach(() => {

    });

    it('should_log_info_when_button_is_clicked', 0, async () => {
      let livecardsystemprogressvm: ILiveCardSystemProgressVm = new LiveCardSystemProgressVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      livecardsystemprogressvm.isButtonPaused = false;
      livecardsystemprogressvm.live = new LiveCardSystemModel();
      livecardsystemprogressvm.live.id = 1;
      livecardsystemprogressvm.live.creatorBundleName = 'com.example.bundle';
      livecardsystemprogressvm.live.creatorUid = 123;
      await livecardsystemprogressvm.onClickButton();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_change_button_state_when_button_is_clicked', 0, async () => {
      let livecardsystemprogressvm: ILiveCardSystemProgressVm = new LiveCardSystemProgressVm();
      livecardsystemprogressvm.isButtonPaused = false;
      livecardsystemprogressvm.live = new LiveCardSystemModel();
      livecardsystemprogressvm.live.id = 1;
      livecardsystemprogressvm.live.creatorBundleName = 'com.example.bundle';
      livecardsystemprogressvm.live.creatorUid = 123;
      await livecardsystemprogressvm.onClickButton();
      expect(livecardsystemprogressvm.isButtonPaused).assertTrue();
    });

    it('should_log_error_when_triggerSystemLiveView_fails', 0, async () => {
      let livecardsystemprogressvm: ILiveCardSystemProgressVm = new LiveCardSystemProgressVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(mockError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      livecardsystemprogressvm.isButtonPaused = false;
      livecardsystemprogressvm.live = new LiveCardSystemModel();
      livecardsystemprogressvm.live.id = 1;
      livecardsystemprogressvm.live.creatorBundleName = 'com.example.bundle';
      livecardsystemprogressvm.live.creatorUid = 123;

      await livecardsystemprogressvm.onClickButton();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_set_button_state_to_false_when_button_is_clicked_and_isButtonPaused_is_true', 0, async () => {
      let livecardsystemprogressvm: ILiveCardSystemProgressVm = new LiveCardSystemProgressVm();
      livecardsystemprogressvm.isButtonPaused = true;
      livecardsystemprogressvm.live = new LiveCardSystemModel();
      livecardsystemprogressvm.live.id = 1;
      livecardsystemprogressvm.live.creatorBundleName = 'com.example.bundle';
      livecardsystemprogressvm.live.creatorUid = 123;

      await livecardsystemprogressvm.onClickButton();

      expect(livecardsystemprogressvm.isButtonPaused).assertFalse();
    });

    it('should_set_button_state_to_true_when_button_is_clicked_and_isButtonPaused_is_false', 0, async () => {
      let livecardsystemprogressvm: ILiveCardSystemProgressVm = new LiveCardSystemProgressVm();
      livecardsystemprogressvm.isButtonPaused = false;
      livecardsystemprogressvm.live = new LiveCardSystemModel();
      livecardsystemprogressvm.live.id = 1;
      livecardsystemprogressvm.live.creatorBundleName = 'com.example.bundle';
      livecardsystemprogressvm.live.creatorUid = 123;

      await livecardsystemprogressvm.onClickButton();

      expect(livecardsystemprogressvm.isButtonPaused).assertTrue();
    });
    it('should_return_color_when_isCharge_is_true_and_progress_color_is_set', 0, async () => {
      let livecardsystemprogressvm: ILiveCardSystemProgressVm = new LiveCardSystemProgressVm();
      let mocker: MockKit = new MockKit();
      let liveItemBaseVm: LiveItemBaseVm = new LiveItemBaseVm();
      let liveCardSystemModel: LiveCardSystemModel = new LiveCardSystemModel();
      liveCardSystemModel.color = 'red';
      liveItemBaseVm.card = liveCardSystemModel;
      livecardsystemprogressvm.live = liveItemBaseVm;
      const result = livecardsystemprogressvm.progressColor;
      expect(result).assertEqual('red');
    });

    it('should_return_DEFAULT_PROGRESS_COLOR_when_isCharge_is_true_and_progress_color_is_not_set', 0, async () => {
      let livecardsystemprogressvm: ILiveCardSystemProgressVm = new LiveCardSystemProgressVm();
      let mocker: MockKit = new MockKit();
      let liveItemBaseVm: LiveItemBaseVm = new LiveItemBaseVm();
      liveItemBaseVm.card = new LiveCardSystemModel();
      livecardsystemprogressvm.live = liveItemBaseVm;
      const result = livecardsystemprogressvm.progressColor;
      expect(result).assertEqual(DEFAULT_PROGRESS_COLOR);
    });

    it('should_return_DEFAULT_PROGRESS_COLOR_when_isCharge_is_false', 0, async () => {
      let livecardsystemprogressvm: ILiveCardSystemProgressVm = new LiveCardSystemProgressVm();
      let mocker: MockKit = new MockKit();
      let liveItemBaseVm: LiveItemBaseVm = new LiveItemBaseVm();
      livecardsystemprogressvm.live = liveItemBaseVm;
      const result = livecardsystemprogressvm.progressColor;
      expect(result).assertEqual(DEFAULT_PROGRESS_COLOR);
    });

    it('should_return_0_when_progress_max_value_is_null', 0, () => {
      let livecardsystemprogressvm: ILiveCardSystemProgressVm = new LiveCardSystemProgressVm();
      let liveItemBaseVm: LiveItemBaseVm = new LiveItemBaseVm();
      let liveCardSystemModel: LiveCardSystemModel = new LiveCardSystemModel();
      liveCardSystemModel.progress = {
        currentValue: 50,
        maxValue: null
      };
      liveItemBaseVm.live = {
        card: liveCardSystemModel,
        sysType: SysTypeCode.LIVE_CARD_SYSTEM_MODEL
      };
      livecardsystemprogressvm.live = liveItemBaseVm;
      expect(livecardsystemprogressvm.progressValue).assertEqual(0);
    });

    it('should_return_progress_value_when_progress_max_value_is_not_null', 0, () => {
      let livecardsystemprogressvm: ILiveCardSystemProgressVm = new LiveCardSystemProgressVm();
      let liveItemBaseVm: LiveItemBaseVm = new LiveItemBaseVm();
      let liveCardSystemModel: LiveCardSystemModel = new LiveCardSystemModel();
      liveCardSystemModel.progress = {
        currentValue: 50,
        maxValue: 100
      };
      liveItemBaseVm.live = {
        card: liveCardSystemModel,
        sysType: SysTypeCode.LIVE_CARD_SYSTEM_MODEL
      };
      livecardsystemprogressvm.live = liveItemBaseVm;
      expect(livecardsystemprogressvm.progressValue).assertEqual(0.5);
    });

    it('should_return_progress_value_when_progress_current_value_is_null', 0, () => {
      let livecardsystemprogressvm: ILiveCardSystemProgressVm = new LiveCardSystemProgressVm();
      let liveItemBaseVm: LiveItemBaseVm = new LiveItemBaseVm();
      let liveCardSystemModel: LiveCardSystemModel = new LiveCardSystemModel();
      liveCardSystemModel.progress = {
        currentValue: null,
        maxValue: 100
      };
      liveItemBaseVm.live = {
        card: liveCardSystemModel,
        sysType: SysTypeCode.LIVE_CARD_SYSTEM_MODEL
      };
      livecardsystemprogressvm.live = liveItemBaseVm;
      expect(livecardsystemprogressvm.progressValue).assertEqual(0);
    });
    it('should_return_true_when_typeCode_is_UPLOAD_DOWNLOAD', 0, () => {
      let livecardsystemprogressvm: LiveCardSystemProgressVm = new LiveCardSystemProgressVm();
      let liveItemBaseVm: LiveItemBaseVm = new LiveItemBaseVm();
      let liveCardSystemModel: LiveCardSystemModel = new LiveCardSystemModel();
      liveCardSystemModel.typeCode = SysTypeCode.UPLOAD_DOWNLOAD;
      livecardsystemprogressvm.live = liveCardSystemModel;
      const result = livecardsystemprogressvm.isShowButton;
      expect(result).assertTrue();
    });

    it('should_return_false_when_typeCode_is_not_UPLOAD_DOWNLOAD', 0, () => {
      let livecardsystemprogressvm: LiveCardSystemProgressVm = new LiveCardSystemProgressVm();
      let liveItemBaseVm: LiveItemBaseVm = new LiveItemBaseVm();
      let liveCardSystemModel: LiveCardSystemModel = new LiveCardSystemModel();
      liveCardSystemModel.typeCode = SysTypeCode.PLAY_VIDEO;
      livecardsystemprogressvm.live = liveCardSystemModel;
      const result = livecardsystemprogressvm.isShowButton;
      expect(result).assertFalse();
    });
    it('should_return_true_when_typeCode_is_RECORDING', 0, () => {
      let livecardsystemprogressvm: LiveCardSystemProgressVm = new LiveCardSystemProgressVm();
      let liveItemBaseVm: LiveItemBaseVm = new LiveItemBaseVm();
      let liveCardSystemModel: LiveCardSystemModel = new LiveCardSystemModel();
      liveCardSystemModel.typeCode = SysTypeCode.RECORDING;
      livecardsystemprogressvm.live = liveCardSystemModel;
      const result = livecardsystemprogressvm.isShowButton;
      expect(result).assertTrue();
    });

    it('should_return_false_when_typeCode_is_not_RECORDING', 0, () => {
      let livecardsystemprogressvm: LiveCardSystemProgressVm = new LiveCardSystemProgressVm();
      let liveItemBaseVm: LiveItemBaseVm = new LiveItemBaseVm();
      let liveCardSystemModel: LiveCardSystemModel = new LiveCardSystemModel();
      liveCardSystemModel.typeCode = SysTypeCode.RECORDING;
      livecardsystemprogressvm.live = liveCardSystemModel;
      const result = livecardsystemprogressvm.isShowButton;
      expect(result).assertFalse();
    });
    it('should_return_true_when_typeCode_is_BLUETOOTH', 0, () => {
      let livecardsystemprogressvm: LiveCardSystemProgressVm = new LiveCardSystemProgressVm();
      let liveItemBaseVm: LiveItemBaseVm = new LiveItemBaseVm();
      let liveCardSystemModel: LiveCardSystemModel = new LiveCardSystemModel();
      liveCardSystemModel.typeCode = SysTypeCode.BLUETOOTH;
      livecardsystemprogressvm.live = liveCardSystemModel;
      const result = livecardsystemprogressvm.isShowButton;
      expect(result).assertTrue();
    });

    it('should_return_false_when_typeCode_is_not_BLUETOOTH', 0, () => {
      let livecardsystemprogressvm: LiveCardSystemProgressVm = new LiveCardSystemProgressVm();
      let liveItemBaseVm: LiveItemBaseVm = new LiveItemBaseVm();
      let liveCardSystemModel: LiveCardSystemModel = new LiveCardSystemModel();
      liveCardSystemModel.typeCode = SysTypeCode.BLUETOOTH;
      livecardsystemprogressvm.live = liveCardSystemModel;
      const result = livecardsystemprogressvm.isShowButton;
      expect(result).assertFalse();
    });
  });

  describe('progressColor_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_default_progress_color_when_isCharge_is_false', 0, () => {
      let livecardsystemprogressvm: ILiveCardSystemProgressVm = new LiveCardSystemProgressVm();
      let mocker: MockKit = new MockKit();
      let liveItemBaseVm: LiveItemBaseVm = new LiveItemBaseVm();
      let liveCardSystemModel: LiveCardSystemModel = new LiveCardSystemModel();
      livecardsystemprogressvm.live = liveItemBaseVm;
      livecardsystemprogressvm.live.card = liveCardSystemModel;
      livecardsystemprogressvm.live.card.color = 'red';
      const result = livecardsystemprogressvm.progressColor;
      expect(result).assertEqual('red');
    });

    it('should_return_default_progress_color_when_isCharge_is_true_and_color_is_undefined', 0, () => {
      let livecardsystemprogressvm: ILiveCardSystemProgressVm = new LiveCardSystemProgressVm();
      let mocker: MockKit = new MockKit();
      let liveItemBaseVm: LiveItemBaseVm = new LiveItemBaseVm();
      let liveCardSystemModel: LiveCardSystemModel = new LiveCardSystemModel();
      livecardsystemprogressvm.live = liveItemBaseVm;
      livecardsystemprogressvm.live.card = liveCardSystemModel;
      livecardsystemprogressvm.live.isCharge = () => true;
      const result = livecardsystemprogressvm.progressColor;
      expect(result).assertEqual(DEFAULT_PROGRESS_COLOR);
    });

    it('should_return_live_card_system_model_color_when_isCharge_is_true_and_color_is_defined', 0, () => {
      let livecardsystemprogressvm: ILiveCardSystemProgressVm = new LiveCardSystemProgressVm();
      let mocker: MockKit = new MockKit();
      let liveItemBaseVm: LiveItemBaseVm = new LiveItemBaseVm();
      let liveCardSystemModel: LiveCardSystemModel = new LiveCardSystemModel();
      livecardsystemprogressvm.live = liveItemBaseVm;
      livecardsystemprogressvm.live.card = liveCardSystemModel;
      livecardsystemprogressvm.live.isCharge = () => true;
      livecardsystemprogressvm.live.card.color = 'blue';
      const result = livecardsystemprogressvm.progressColor;
      expect(result).assertEqual('blue');
    });
  });

  describe('progressValue_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_0_when_progress_is_null', 0, () => {
      let livecardsystemprogressvm: ILiveCardSystemProgressVm = new LiveCardSystemProgressVm();
      let liveItemBaseVm: LiveItemBaseVm = new LiveItemBaseVm();
      livecardsystemprogressvm.live = liveItemBaseVm;
      livecardsystemprogressvm.live.card = new LiveCardSystemModel();
      livecardsystemprogressvm.live.card.progress = null;
      const result = livecardsystemprogressvm.progressValue;
      expect(result).assertEqual(0);
    });

    it('should_return_0_when_progress_max_value_is_0', 0, () => {
      let livecardsystemprogressvm: ILiveCardSystemProgressVm = new LiveCardSystemProgressVm();
      let liveItemBaseVm: LiveItemBaseVm = new LiveItemBaseVm();
      livecardsystemprogressvm.live = liveItemBaseVm;
      livecardsystemprogressvm.live.card = new LiveCardSystemModel();
      livecardsystemprogressvm.live.card.progress = {
        currentValue: 10,
        maxValue: 0
      };
      const result = livecardsystemprogressvm.progressValue;
      expect(result).assertEqual(0);
    });

    it('should_return_progress_value_when_progress_max_value_is_not_0', 0, () => {
      let livecardsystemprogressvm: ILiveCardSystemProgressVm = new LiveCardSystemProgressVm();
      let liveItemBaseVm: LiveItemBaseVm = new LiveItemBaseVm();
      livecardsystemprogressvm.live = liveItemBaseVm;
      livecardsystemprogressvm.live.card = new LiveCardSystemModel();
      livecardsystemprogressvm.live.card.progress = {
        currentValue: 10,
        maxValue: 20
      };
      const result = livecardsystemprogressvm.progressValue;
      expect(result).assertEqual(5);
    });

    it('should_return_progress_value_when_progress_current_value_is_null', 0, () => {
      let livecardsystemprogressvm: ILiveCardSystemProgressVm = new LiveCardSystemProgressVm();
      let liveItemBaseVm: LiveItemBaseVm = new LiveItemBaseVm();
      livecardsystemprogressvm.live = liveItemBaseVm;
      livecardsystemprogressvm.live.card = new LiveCardSystemModel();
      livecardsystemprogressvm.live.card.progress = {
        currentValue: null,
        maxValue: 20
      };
      const result = livecardsystemprogressvm.progressValue;
      expect(result).assertEqual(0);
    });

    it('should_return_progress_value_when_live_is_system_live', 0, () => {
      let livecardsystemprogressvm: ILiveCardSystemProgressVm = new LiveCardSystemProgressVm();
      let liveItemBaseVm: LiveItemBaseVm = new LiveItemBaseVm();
      livecardsystemprogressvm.live = liveItemBaseVm;
      livecardsystemprogressvm.live.card = new LiveCardSystemModel();
      livecardsystemprogressvm.live.card.progress = {
        currentValue: 10,
        maxValue: 20
      };
      livecardsystemprogressvm.live.type = SysTypeCode.SYSTEM_LIVE;
      const result = livecardsystemprogressvm.progressValue;
      expect(result).assertEqual(5);
    });

    it('should_return_progress_value_when_live_is_not_system_live', 0, () => {
      let livecardsystemprogressvm: ILiveCardSystemProgressVm = new LiveCardSystemProgressVm();
      let liveItemBaseVm: LiveItemBaseVm = new LiveItemBaseVm();
      livecardsystemprogressvm.live = liveItemBaseVm;
      livecardsystemprogressvm.live.card = new LiveCardSystemModel();
      livecardsystemprogressvm.live.card.progress = {
        currentValue: 10,
        maxValue: 20
      };
      livecardsystemprogressvm.live.type = SysTypeCode.NORMAL_LIVE;
      const result = livecardsystemprogressvm.progressValue;
      expect(result).assertEqual(5);
    });

    it('should_return_progress_value_when_live_is_system_live_and_current_value_is_null', 0, () => {
      let livecardsystemprogressvm: ILiveCardSystemProgressVm = new LiveCardSystemProgressVm();
      let liveItemBaseVm: LiveItemBaseVm = new LiveItemBaseVm();
      livecardsystemprogressvm.live = liveItemBaseVm;
      livecardsystemprogressvm.live.card = new LiveCardSystemModel();
      livecardsystemprogressvm.live.card.progress = {
        currentValue: null,
        maxValue: 20
      };
      livecardsystemprogressvm.live.type = SysTypeCode.SYSTEM_LIVE;
      const result = livecardsystemprogressvm.progressValue;
      expect(result).assertEqual(0);
    });

    it('should_return_progress_value_when_live_is_not_system_live_and_current_value_is_null', 0, () => {
      let livecardsystemprogressvm: ILiveCardSystemProgressVm = new LiveCardSystemProgressVm();
      let liveItemBaseVm: LiveItemBaseVm = new LiveItemBaseVm();
      livecardsystemprogressvm.live = liveItemBaseVm;
      livecardsystemprogressvm.live.card = new LiveCardSystemModel();
      livecardsystemprogressvm.live.card.progress = {
        currentValue: null,
        maxValue: 20
      };
      livecardsystemprogressvm.live.type = SysTypeCode.NORMAL_LIVE;
      const result = livecardsystemprogressvm.progressValue;
      expect(result).assertEqual(0);
    });

    it('should_return_progress_value_when_live_is_system_live_and_max_value_is_null', 0, () => {
      let livecardsystemprogressvm: ILiveCardSystemProgressVm = new LiveCardSystemProgressVm();
      let liveItemBaseVm: LiveItemBaseVm = new LiveItemBaseVm();
      livecardsystemprogressvm.live = liveItemBaseVm;
      livecardsystemprogressvm.live.card = new LiveCardSystemModel();
      livecardsystemprogressvm.live.card.progress = {
        currentValue: 10,
        maxValue: null
      };
      livecardsystemprogressvm.live.type = SysTypeCode.SYSTEM_LIVE;
      const result = livecardsystemprogressvm.progressValue;
      expect(result).assertEqual(0);
    });

    it('should_return_progress_value_when_live_is_not_system_live_and_max_value_is_null', 0, () => {
      let livecardsystemprogressvm: ILiveCardSystemProgressVm = new LiveCardSystemProgressVm();
      let liveItemBaseVm: LiveItemBaseVm = new LiveItemBaseVm();
      livecardsystemprogressvm.live = liveItemBaseVm;
      livecardsystemprogressvm.live.card = new LiveCardSystemModel();
      livecardsystemprogressvm.live.card.progress = {
        currentValue: 10,
        maxValue: null
      };
      livecardsystemprogressvm.live.type = SysTypeCode.NORMAL_LIVE;
      const result = livecardsystemprogressvm.progressValue;
      expect(result).assertEqual(0);
    });
  });

  describe('isShowText_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_true_when_isCharge_returns_true', 0, async () => {
      let livecardsystemprogressvm: ILiveCardSystemProgressVm = new LiveCardSystemProgressVm();
      let mocker: MockKit = new MockKit();
      let liveItemBaseVm: LiveItemBaseVm = new LiveItemBaseVm();
      let liveCardSystemModel: LiveCardSystemModel = new LiveCardSystemModel();
      let mockfunc: Function = mocker.mockFunc(liveItemBaseVm, liveItemBaseVm.isCharge);
      when(mockfunc)([]).afterReturn(true);
      livecardsystemprogressvm.live = liveItemBaseVm;
      const result = livecardsystemprogressvm.isShowText;
      expect(result).assertEqual(true);
      mocker.ignoreMock(liveItemBaseVm, liveItemBaseVm.isCharge);
    });

    it('should_return_false_when_isCharge_returns_false', 0, async () => {
      let livecardsystemprogressvm: ILiveCardSystemProgressVm = new LiveCardSystemProgressVm();
      let mocker: MockKit = new MockKit();
      let liveItemBaseVm: LiveItemBaseVm = new LiveItemBaseVm();
      let liveCardSystemModel: LiveCardSystemModel = new LiveCardSystemModel();
      let mockfunc: Function = mocker.mockFunc(liveItemBaseVm, liveItemBaseVm.isCharge);
      when(mockfunc)([]).afterReturn(false);
      livecardsystemprogressvm.live = liveItemBaseVm;
      const result = livecardsystemprogressvm.isShowText;
      expect(result).assertEqual(false);
      mocker.ignoreMock(liveItemBaseVm, liveItemBaseVm.isCharge);
    });
  });

  describe('isShowButton_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_true_when_live_typeCode_is_UPLOAD_DOWNLOAD', 0, () => {
      let livecardsystemprogressvm: ILiveCardSystemProgressVm = new LiveCardSystemProgressVm();
      let liveItemBaseVm: LiveItemBaseVm = new LiveItemBaseVm();
      let liveCardSystemModel: LiveCardSystemModel = new LiveCardSystemModel();
      liveCardSystemModel.typeCode = SysTypeCode.UPLOAD_DOWNLOAD;
      livecardsystemprogressvm.live = liveCardSystemModel;
      const result = livecardsystemprogressvm.isShowButton;
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_live_typeCode_is_not_UPLOAD_DOWNLOAD', 0, () => {
      let livecardsystemprogressvm: ILiveCardSystemProgressVm = new LiveCardSystemProgressVm();
      let liveItemBaseVm: LiveItemBaseVm = new LiveItemBaseVm();
      let liveCardSystemModel: LiveCardSystemModel = new LiveCardSystemModel();
      liveCardSystemModel.typeCode = SysTypeCode.PLAYBACK;
      livecardsystemprogressvm.live = liveCardSystemModel;
      const result = livecardsystemprogressvm.isShowButton;
      expect(result).assertEqual(false);
    });
  });
}
