/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { Constants } from '../utils/PictureInPictureConstants';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { SCBPiPManager } from '../SCBPiPManager';

const TAG = 'LiveControlPanel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
const LARGE_ICON_PIP_WIDTH_MINIMUM = 116;

@Component
export struct LiveControlPanel {
  @State isPlaying: boolean = true;
  @Consume hideControlDelay: boolean;
  @Consume enableLinearGradient: boolean;
  @State sizeIndex: number = 0;
  @State isMute: boolean = true;
  @State spaceIndex: number = 0;
  private controlGroups: number[] | undefined = [];
  private pipControlStatusInfoList?: sceneSessionManager.PiPControlStatusInfo[] | undefined = [];
  private pipControlEnableInfoList?: sceneSessionManager.PiPControlEnableInfo[] | undefined = [];
  @State private controlEnableMap: Map<sceneSessionManager.PiPControlType, boolean> = new Map([
    [sceneSessionManager.PiPControlType.VIDEO_PLAY_PAUSE, true],
    [sceneSessionManager.PiPControlType.MUTE_SWITCH, true],
  ]);

  initCallBacks() {
    SCBPiPManager.getInstance().registerControlStatusChangeCallback((controlType: sceneSessionManager.PiPControlType,
      status: sceneSessionManager.PiPControlStatus) => {
      this.onSessionControlStatusChange(controlType, status);
    });
  }

  initControlStatus() {
    if (this.pipControlStatusInfoList === undefined || this.pipControlEnableInfoList === undefined) {
      return;
    }
    for (const pipControlStatusInfo of this.pipControlStatusInfoList) {
      this.setControlStatus(pipControlStatusInfo.controlType, pipControlStatusInfo.status);
    }
    for (const pipControlEnableInfo of this.pipControlEnableInfoList) {
      this.setControlEnable(pipControlEnableInfo.controlType,
        pipControlEnableInfo.enabled === sceneSessionManager.PiPControlStatus.ENABLED);
    }
  }

  onSessionControlStatusChange(controlType: sceneSessionManager.PiPControlType,
    status: sceneSessionManager.PiPControlStatus) {
    if (status === sceneSessionManager.PiPControlStatus.ENABLED ||
      status === sceneSessionManager.PiPControlStatus.DISABLED) {
      SCBPiPManager.getInstance().setControlGroupsControlEnable(controlType, status);
      this.setControlEnable(controlType, status === sceneSessionManager.PiPControlStatus.ENABLED);
      return;
    }
    SCBPiPManager.getInstance().setControlGroupsControlStatus(controlType, status);
    this.setControlStatus(controlType, status);
  }

  setControlStatus(controlType: sceneSessionManager.PiPControlType,
    status: sceneSessionManager.PiPControlStatus) {
    let controlStatus : boolean = true;
    if (status === sceneSessionManager.PiPControlStatus.OPEN) {
      controlStatus = true;
    } else if (status === sceneSessionManager.PiPControlStatus.CLOSE) {
      controlStatus = false;
    } else {
      log.showInfo('status is invalid');
      return;
    }
    switch (controlType) {
      case sceneSessionManager.PiPControlType.VIDEO_PLAY_PAUSE:
        this.isPlaying = controlStatus;
        break;
      case sceneSessionManager.PiPControlType.MUTE_SWITCH:
        this.isMute = controlStatus;
        break;
      default:
        log.showInfo(`onSessionControlEnableChange controlType is invalid`);
        break;
    }
    log.showInfo(` controlType: ${controlType}, status: ${status}`);
  }

  setControlEnable(controlType: sceneSessionManager.PiPControlType, enabled: boolean) {
    if (!this.controlEnableMap.has(controlType)) {
      log.showInfo('controlType is invalid');
      return;
    }
    this.controlEnableMap.set(controlType, enabled);
    log.showInfo(`controlType: ${controlType}, enabled: ${enabled}`);
  }

  aboutToAppear(): void {
    this.pipControlStatusInfoList = SCBPiPManager.getInstance().getTemplateInfo()?.pipControlStatusInfoList;
    this.pipControlEnableInfoList = SCBPiPManager.getInstance().getTemplateInfo()?.pipControlEnableInfoList;
    this.controlGroups = SCBPiPManager.getInstance().getTemplateInfo()?.controlGroup;
    this.initCallBacks();
    this.initControlStatus();
    if (this.controlGroups === undefined || this.controlGroups === null) {
      return;
    }
    if (this.controlGroups.length === Constants.MAX_ICON_NUM) {
      this.spaceIndex = 1;
    }
  }

  @Builder
  pauseBuilder() {
    Button({ type: ButtonType.Circle }) {
      Image(this.isPlaying ? $r('sys.media.ohos_ic_public_pause') : $r('sys.media.ohos_ic_public_play'))
        .fillColor($r('sys.color.ohos_id_color_primary_contrary'))
        .objectFit(ImageFit.Contain)
        .size({
          width: Constants.DEFAULT_BIG_BUTTON_SIZE,
          height: Constants.DEFAULT_BIG_BUTTON_SIZE
        })
    }
    .backgroundColor('#00FFFFFF')
    .size({
      width: Constants.DEFAULT_BIG_BUTTON_SIZE,
      height: Constants.DEFAULT_BIG_BUTTON_SIZE
    })
    .enabled(this.controlEnableMap.get(sceneSessionManager.PiPControlType.VIDEO_PLAY_PAUSE))
    .attributeModifier(Constants.OVERLAY_BUTTON_MODIFIER)
    .animation({ curve: Constants.OVERLAY_BUTTON_CLICK_EFFECT_CURVE })
    .onClick(() => {
      this.isPlaying = !this.isPlaying;
      this.hideControlDelay = true;
      SCBPiPManager.getInstance().sendActionControlEvent(Constants.PLAY_BACK_STATE_CHANGE,
        this.isPlaying ? Constants.ACTION_STATUS_ON : Constants.ACTION_STATUS_OFF);
      SCBPiPManager.getInstance().sendControlEvent(sceneSessionManager.PiPControlType.VIDEO_PLAY_PAUSE, this.isPlaying ?
        sceneSessionManager.PiPControlStatus.PLAY : sceneSessionManager.PiPControlStatus.PAUSE);
    })
  }

  @Builder
  muteButtonBuilder() {
    Button({ type: ButtonType.Circle }) {
      Image(this.isMute ? $r('sys.media.ohos_ic_public_sound') : $r('sys.media.ohos_ic_public_sound_off'))
        .size({
          width: Constants.DEFAULT_BIG_BUTTON_SIZE,
          height: Constants.DEFAULT_BIG_BUTTON_SIZE
        })
        .fillColor($r('sys.color.ohos_id_color_primary_contrary'))
        .objectFit(ImageFit.Contain)
    }
    .size({
      width: Constants.DEFAULT_BIG_BUTTON_SIZE,
      height: Constants.DEFAULT_BIG_BUTTON_SIZE
    })
    .backgroundColor('#00FFFFFF')
    .enabled(this.controlEnableMap.get(sceneSessionManager.PiPControlType.MUTE_SWITCH))
    .attributeModifier(Constants.OVERLAY_BUTTON_MODIFIER)
    .animation({ curve: Constants.OVERLAY_BUTTON_CLICK_EFFECT_CURVE })
    .onClick(() => {
      this.hideControlDelay = true;
      this.isMute = !this.isMute;
      SCBPiPManager.getInstance().sendActionControlEvent(Constants.VOICE_STATE_CHANGE, this.isMute ?
        Constants.ACTION_STATUS_ON : Constants.ACTION_STATUS_OFF);
      SCBPiPManager.getInstance().sendControlEvent(sceneSessionManager.PiPControlType.MUTE_SWITCH, this.isMute ?
        sceneSessionManager.PiPControlStatus.OPEN : sceneSessionManager.PiPControlStatus.CLOSE);
    })
  }

  @Builder
  buttonGroupBuilder() {
    ForEach(this.controlGroups, (item: number) => {
      if (item === Constants.LIVE_PLAY_PAUSE) {
        this.pauseBuilder();
      }

      if (item === Constants.LIVE_MUTE_SWITCH) {
        this.muteButtonBuilder()
      }
    }, (item: string) => item)
  }

  build() {
    RelativeContainer() {
      Row({ space: Constants.ITEM_SPACE[this.spaceIndex][this.sizeIndex] }) {
        this.buttonGroupBuilder();
      }
      .size({ width: '100%', height: Constants.DEFAULT_BIG_BUTTON_SIZE })
      .justifyContent(FlexAlign.Center)
      .margin({ bottom: 12, top: 12 })
      .alignRules({
        top: { anchor: '__container__', align: VerticalAlign.Top },
        middle: { anchor: '__container__', align: HorizontalAlign.Center }
      })
      .id('control_play')
    }
    .width('100%')
    .height(56)
    .linearGradient({
      angle: 0,
      colors: [['#4D000000', 0.0], ['#00000000', this.enableLinearGradient ? 1.0 : 0.0]]
    })
    .onAreaChange((oldValue: Area, newValue: Area) => {
      if (oldValue.width === newValue.width) {
        return;
      }
      this.sizeIndex = newValue.width >= LARGE_ICON_PIP_WIDTH_MINIMUM ? 1 : 0;
    })
    .alignRules({
      bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
      left: { anchor: '__container__', align: HorizontalAlign.Start }
    })
    .hitTestBehavior(HitTestMode.Transparent)
    .id('live_control')
  }
}