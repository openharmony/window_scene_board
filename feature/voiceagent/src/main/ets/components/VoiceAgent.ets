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

import { LanguageUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { RTLUtil } from '@ohos/componenthelper';
import { VoiceConstant } from '../constant/VoiceConstant';
import { JsonUtil } from '../utils/JsonUtil';
import { VoiceService } from '../model/VoiceService';
import { SupportUtil } from '../utils/SupportUtil';

const TAG: string = 'VoiceAgent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

// 定义二维点
type Point = [number, number];

@Component
export struct VoiceAgent {
  @State isErrorHappen: boolean = false;
  private panOptionStack: PanGestureOptions = new PanGestureOptions({
    distance: 5,
    direction: LanguageUtils.isMirrorLanguage() ? PanDirection.Right : PanDirection.Left
  });
  onActionStart: Function = () => {
  };
  onActionUpdate: Function = () => {
  };
  onActionEnd: Function = () => {
  };

  @Prop @Watch('onTranslateXChange') mTranslateX: number = 0;

  @Prop @Watch('onScaleChange') mScale: number = 0;

  @StorageProp(VoiceConstant.isFullShown) @Watch('onFullShowChange') isFullShown: boolean = false;

  @StorageProp(VoiceConstant.isFoldStatus) @Watch('onFoldStatusChange') isFoldStatus: boolean = false;

  @StorageProp('isNegativeScrollGesture') @Watch('onGestureStartChange') isNegativeScrollGesture: boolean = false;

  private showStatusBar: () => void = () => {

  };

  private hideStatusBar: () => void = () => {

  };

  private exitNegativeOneScreenNoAnim: () => void = () => {

  };

  // 折叠状态改变
  onFoldStatusChange(): void {
    log.showInfo(`onFoldStatusChange ${this.isFoldStatus}`);
  }

  // 是否完全展示负一屏
  onFullShowChange(): void {
    log.showInfo(`onFullShowChange ${this.isFullShown}`);
  }

  // 手势开始的监听
  onGestureStartChange(): void {
    if (this.isNegativeScrollGesture && !this.isFullShown) {
      VoiceService.getInstance().startDrag();
    }
  }

  // 横向位置移动改变监听
  onTranslateXChange(): void {
    log.showInfo(`onTranslateXChange ${this.mTranslateX}`);
  }

  onScaleChange(): void {
    log.showInfo(`onScaleChange ${this.mScale}`);
  }

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
    VoiceService.getInstance().updateBundleChange = () => {
      log.showInfo(`updateBundle change`);
      this.isErrorHappen = !SupportUtil.isSupportVoice();
    }
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
  }

  build() {
    RelativeContainer() {
      if (!this.isErrorHappen) {
        UIExtensionComponent({
          bundleName: 'com.ohos.vassistant',
          abilityName: 'LiveMainUiExtension',
          parameters: {
            'ability.want.params.uiExtensionType': 'sys/commonUI',
          },
        })
          .onRemoteReady((proxy: UIExtensionProxy) => {
            log.showInfo(`onRemoteReady ${this.isFullShown}`);
            VoiceService.getInstance().setUiProxy(proxy);
            if (this.isFullShown) {
              VoiceService.getInstance().updateNegativeScreenVisibility(true);
            }
          })
          .size({ width: '100%', height: '100%' })
          .onReceive((data) => {
            log.showInfo('onReceive: ' + JSON.stringify(data))
            this.receiveVAssistantData(data);
          })
          .onError((error: object) => {
            log.showInfo(`err: ${JsonUtil.parseObjToStr(error)}`);
            this.onError();
          })
          .onRelease(() => {
            log.showInfo(`onRelease`);
            this.onError();
          })
          .onTerminated((info: TerminationInfo) => {
            log.showInfo(`onTerminated`);
            this.onError();
          })
      }
    }
    .size({ width: '100%', height: '100%' })
    .gesture(
      PanGesture(this.panOptionStack)
        .onActionStart((event) => {
          this.onActionStart(event);
        })
        .onActionUpdate((event) => {
          this.onActionUpdate(event);
        })
        .onActionEnd((event) => {
          this.onActionEnd(event);
        })
    )
    .onVisibleAreaChange([0.0, 1.0], (isVisible: boolean, currentRatio: number) => {
      log.showInfo(`onVisibleAreaChange ${isVisible}`);
      if (isVisible) {
        this.isErrorHappen = !SupportUtil.isSupportVoice();
      }
      AppStorage.setOrCreate<boolean>(VoiceConstant.isShowVoiceLive, isVisible);
    })
  }

  onError() {
    this.isErrorHappen = true;
    this.exitNegativeOneScreenNoAnim();
    setTimeout(() => {
      this.isErrorHappen = !SupportUtil.isSupportVoice();
    }, 300);
  }

  receiveVAssistantData(data: Record<string, Object>): void {
    if (!data) {
      log.showInfo('receive no data');
      return;
    }
    let action: string = data.action as string;
    let value: string = data.value as string;
    switch (action) {
      case VoiceConstant.EXIT_NEGATIVE_SCREEN_EVENT:
        if (this.mTranslateX === 0) {
          // 在stack里
          this.exitNegativeOneScreenNoAnim();
        }
        break;
      case VoiceConstant.KILL_VOICE_EXTENSION:
        AppStorage.set<boolean>(VoiceConstant.isVoiceExtExist, false);
        break;
      case VoiceConstant.isLongPressStartAiPanel:
        AppStorage.set<boolean>(VoiceConstant.isLongPressStartAiPanel, value === 'true');
        break;
      case VoiceConstant.CONTROL_STATUS_BAR_VISIBLE:
        if (value === 'true') {
          this.showStatusBar?.();
        } else {
          this.hideStatusBar?.();
        }
        break;
    }
  }
}