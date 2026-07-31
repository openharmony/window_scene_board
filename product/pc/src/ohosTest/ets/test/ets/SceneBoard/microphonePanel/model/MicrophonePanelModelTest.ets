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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level, Size, TestType } from '@ohos/hypium';
import { hilog } from '@kit.PerformanceAnalysisKit';
import MicrophonePanelViewModel, {
  AppCapturerCardItemProp,
  AppCapturerCardItemsForUIListener,
  CurrentInputDeviceChangeForUIListener,
  CurrentMicrophoneMuteStatusForUIListener,
  InputCardItemProp,
  InputDevicesChangeForUIListener
} from '@ohos/pcbase/src/main/ets/SceneBoard/microphonepanel/viewmodel/MicrophonePanelViewModel';
import AIAudioEffectSettingModel, {
  callReinforceStatusChangeListener,
  effectNoiseReductStatusChangeListener,
  voiceCancelStatusChangeListener,
  enhanceNoiseReductStatusChangeListener,
  AIAudioEffectProp,
  AIAudioEnhanceProp
} from '@ohos/pcbase/src/main/ets/SceneBoard/microphonepanel/model/AudioEffectSettingModel';
import XmlParseUtil from '@ohos/pcbase/src/main/ets/SceneBoard/microphonepanel/util/XmlParseUtil';
import MicrophonePanelModel from '@ohos/pcbase/src/main/ets/SceneBoard/microphonepanel/model/MicrophonePanelModel';
import { PcAudioDevice } from '@ohos/pcbase/src/main/ets/SceneBoard/microphonepanel/PcAudioDevice';
import audio from '@ohos.multimedia.audio';

const TAG = 'MicrophonePanelModelTest';

export default function MicrophonePanelModelTest() {
  let inputDevicesChangeForUIListener: InputDevicesChangeForUIListener = {
    onInputDevicesChangeForUI: (devices: InputCardItemProp[]) => {
    }
  }

  let currentInputDeviceChangeForUIListener: CurrentInputDeviceChangeForUIListener = {
    onCurrentInputDeviceChangeForUI: (idex: number) => {
    }
  };

  let currentMicrophoneMuteStatusForUIListener: CurrentMicrophoneMuteStatusForUIListener = {
    onCurrentMicrophoneMuteStatusForUI: (isMute: boolean) => {
    }
  }

  let appCapturerCardItemsForUIListener: AppCapturerCardItemsForUIListener = {
    onCapturerInfoArrayForUI: (appCapturerCardItems: AppCapturerCardItemProp[]) => {
    }
  };

  let voiceCancelStatusChangeForUIListener: voiceCancelStatusChangeListener = {
    onVoiceCancelStatusChange: (enhanceProp: string) => {
    }
  };

  let effectNoiseReductStatusChangeListener: effectNoiseReductStatusChangeListener = {
    onEffectNoiseReductStatusChange: (enhanceProp: string) => {
    }
  };

  let callReinforceStatusChangeForUIListener: callReinforceStatusChangeListener = {
    onCallReinforceStatusChange: (enhanceProp: string) => {
    }
  };

  let enhanceNoiseReductStatusChangeListener: enhanceNoiseReductStatusChangeListener = {
    onEnhanceNoiseReductStatusChange: (enhanceProp: string) => {
    }
  };
  describe('MicrophonePanelModelTest', () => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    });
    afterEach((): void => {

    });
    afterAll((): void => {
      hilog.info(0x0000, TAG, 'afterAll all it pass');
    });

    it('registerMicrophonePanelViewModel', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        MicrophonePanelViewModel.registerInputDevicesForUIListener(inputDevicesChangeForUIListener);
        MicrophonePanelViewModel.registerCurrentInputDeviceForUIListener(currentInputDeviceChangeForUIListener);
        MicrophonePanelViewModel.
        registerCurrentMicrophoneMuteStatusForUIListener(currentMicrophoneMuteStatusForUIListener);
        MicrophonePanelViewModel.registerCapturerInfoArrayForUIListener(appCapturerCardItemsForUIListener)
        MicrophonePanelViewModel.unregisterInputDevicesForUIListener(inputDevicesChangeForUIListener);
        MicrophonePanelViewModel.unregisterCurrentInputDeviceForUIListener(currentInputDeviceChangeForUIListener);
        MicrophonePanelViewModel.
        unregisterCurrentMicrophoneMuteStatusForUIListener(currentMicrophoneMuteStatusForUIListener);
        MicrophonePanelViewModel.unregisterCapturerInfoArrayForUIListener(appCapturerCardItemsForUIListener)
      } catch (e) {
        expect(false).assertFail();
        hilog.error(0x0000, TAG, 'registerMicrophonePanelViewModel error' + e);
      }
    });

    it('registerAIAudioEffectSettingModel', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        AIAudioEffectSettingModel.registerVoiceCancelStatusChangeListener(voiceCancelStatusChangeForUIListener);
        AIAudioEffectSettingModel.registerCallReinforceStatusChangeListener(callReinforceStatusChangeForUIListener);
        AIAudioEffectSettingModel.registerEffectNoiseReductStatusChangeListener(effectNoiseReductStatusChangeListener);
        AIAudioEffectSettingModel.
        registerEnhanceNoiseReductStatusChangeListener(enhanceNoiseReductStatusChangeListener);
        AIAudioEffectSettingModel.unregisterVoiceCancelStatusChangeListener(voiceCancelStatusChangeForUIListener);
        AIAudioEffectSettingModel.unregisterCallReinforceStatusChangeListener(callReinforceStatusChangeForUIListener);
        AIAudioEffectSettingModel.
        unregisterEffectNoiseReductStatusChangeListener(effectNoiseReductStatusChangeListener);
        AIAudioEffectSettingModel.
        unregisterEnhanceNoiseReductStatusChangeListener(enhanceNoiseReductStatusChangeListener);
      } catch (e) {
        expect(false).assertFail();
        hilog.error(0x0000, TAG, 'registerAIAudioEffectSettingModel error' + e);
      }
    });

    it('refreshAllStatusInfo', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        MicrophonePanelModel.refreshAllStatusInfo();
      } catch (e) {
        expect(false).assertFail();
        hilog.info(0x0000, TAG, 'getFromMicrophonePanelViewModel error' + e);
      }
    });

    it('getAudioInputDevicesFromModel', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        let audioInputDevices: PcAudioDevice[] = MicrophonePanelModel.getAudioInputDevices();
      } catch (e) {
        expect(false).assertFail();
        hilog.info(0x0000, TAG, 'getAudioInputDevicesFromModel error' + e);
      }
    });

    it('getCurrentInputAudioDeviceIndexFromModel', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        let currentInputAudioDeviceIndex: number = MicrophonePanelModel.getCurrentInputAudioDeviceIndex();
      } catch (e) {
        expect(false).assertFail();
        hilog.error(0x0000, TAG, 'getCurrentInputAudioDeviceIndexFromModel error' + e);
      }
    });

    it('getCurrentMicrophoneMuteStatusFromModel', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        let isMicrophoneMute: boolean = MicrophonePanelModel.getCurrentMicrophoneMuteStatus();
      } catch (e) {
        expect(false).assertFail();
        hilog.error(0x0000, TAG, 'getCurrentMicrophoneMuteStatusFromModel error' + e);
      }
    });

    it('getAppCapturerCardItemsFromModel', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        let appCapturerCardItems: Array<audio.AudioCapturerChangeInfo> =
          MicrophonePanelModel.getCurrentCapturerInfoArray();
      } catch (e) {
        expect(false).assertFail();
        hilog.error(0x0000, TAG, 'getAppCapturerCardItemsFromModel error' + e);
      }
    });

    it('getAudioInputDevices', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        let audioInputDevices: InputCardItemProp[] = MicrophonePanelViewModel.getAudioInputDevices();
      } catch (e) {
        expect(false).assertFail();
        hilog.info(0x0000, TAG, 'getFromMicrophonePanelViewModel error' + e);
      }
    });

    it('getCurrentInputAudioDeviceIndex', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        let currentInputAudioDeviceIndex: number = MicrophonePanelViewModel.getCurrentInputAudioDeviceIndex();
        MicrophonePanelViewModel.selectAudioInputDevice(currentInputAudioDeviceIndex,
          'getCurrentInputAudioDeviceIndex_test');
      } catch (e) {
        expect(false).assertFail();
        hilog.error(0x0000, TAG, 'getFromMicrophonePanelViewModel error' + e);
      }
    });

    it('getCurrentMicrophoneMuteStatus', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        let isMicrophoneMute: boolean = MicrophonePanelViewModel.getCurrentMicrophoneMuteStatus();
        MicrophonePanelViewModel.setMicrophoneMute(!isMicrophoneMute, 'getCurrentMicrophoneMuteStatus_test');
        let appCapturerCardItems: AppCapturerCardItemProp[] = MicrophonePanelViewModel.getAppCapturerCardItems();
      } catch (e) {
        expect(false).assertFail();
        hilog.error(0x0000, TAG, 'getCurrentMicrophoneMuteStatus error' + e);
      }
    });

    it('getAppCapturerCardItems', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        let appCapturerCardItems: AppCapturerCardItemProp[] = MicrophonePanelViewModel.getAppCapturerCardItems();
      } catch (e) {
        expect(false).assertFail();
        hilog.error(0x0000, TAG, 'getAppCapturerCardItems error' + e);
      }
    });

    it('getAIAudioEffectSettingModelStatus', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        let voiceCancelStatus: string = AIAudioEffectSettingModel.getVoiceCancelStatus();
        let effectNoiseReductStatus: string = AIAudioEffectSettingModel.getEffectNoiseReductStatus();
        let callReinforceStatus: string = AIAudioEffectSettingModel.getCallReinforceStatus();
        let enhanceNoiseReductStatus: string = AIAudioEffectSettingModel.getEnhanceNoiseReductStatus();
      } catch (e) {
        expect(false).assertFail();
        hilog.error(0x0000, TAG, 'getAIAudioEffectSettingModelStatus error' + e);
      }
    });

    it('setVoiceCancelStatus', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        AIAudioEffectSettingModel.setVoiceCancelStatus(AIAudioEffectProp.EFFECT_DEFAULT);
      } catch (e) {
        expect(false).assertFail();
        hilog.error(0x0000, TAG, 'setVoiceCancelStatus error' + e);
      }
    });

    it('setEffectNoiseReductStatus', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        AIAudioEffectSettingModel.setEffectNoiseReductStatus(AIAudioEffectProp.NOISE_REDUCT_OFF);
      } catch (e) {
        expect(false).assertFail();
        hilog.error(0x0000, TAG, 'setEffectNoiseReductStatus error' + e);
      }
    });

    it('setCallReinforceStatus', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        AIAudioEffectSettingModel.setCallReinforceStatus(AIAudioEnhanceProp.ENHANCE_MULTIPLE);
      } catch (e) {
        expect(false).assertFail();
        hilog.error(0x0000, TAG, 'setCallReinforceStatus error' + e);
      }
    });

    it('setEnhanceNoiseReductStatus', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        AIAudioEffectSettingModel.setEnhanceNoiseReductStatus(AIAudioEnhanceProp.NOISE_REDUCT_OFF);
      } catch (e) {
        expect(false).assertFail();
        hilog.error(0x0000, TAG, 'setEnhanceNoiseReductStatus error' + e);
      }
    });

    it('getXmlParseUtilInfo', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        let version = XmlParseUtil.getXmlVersion();
        let logSupport = XmlParseUtil.getLogSupport();
        let vocalCancelSupport = XmlParseUtil.getVocalCancelSupport();
        let callNoiseReductforceSupport = XmlParseUtil.getCallNoiseReductforceSupport();
        let callReinforceSupport = XmlParseUtil.getCallReinforceSupport();
        let recordNoiseReductforceSupport = XmlParseUtil.getRecordNoiseReductforceSupport();
        let deviceselectSupport = XmlParseUtil.getDeviceselectSupport();
        let res = XmlParseUtil.getDeviceSupport('');
      } catch (e) {
        expect(false).assertFail();
        hilog.error(0x0000, TAG, 'getXmlParseUtilInfo error' + e);
      }
    });

  });
}