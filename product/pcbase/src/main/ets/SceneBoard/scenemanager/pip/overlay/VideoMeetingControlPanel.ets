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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { Constants } from '../utils/PictureInPictureConstants';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { SCBPiPManager } from '../SCBPiPManager';

const TAG = 'VideoMeetingControlPanel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
@Component
export struct VideoMeetingControlPanel {
  @State isMute: boolean = true;
  @State isCamera: boolean = true;
  @State isMic: boolean = true;
  @State sizeIndex: number = 0;
  @State spaceIndex: number = 0;
  @State controlNum: number = 0;
  @Consume hideControlDelay: boolean;
  @Consume enableLinearGradient: boolean;
  private controlGroups?: number[] | undefined = [];
  private pipControlStatusInfoList?: sceneSessionManager.PiPControlStatusInfo[] | undefined = [];
  private pipControlEnableInfoList?: sceneSessionManager.PiPControlEnableInfo[] | undefined = [];
  @State private controlEnableMap: Map<sceneSessionManager.PiPControlType, boolean> = new Map([
    [sceneSessionManager.PiPControlType.MUTE_SWITCH, true],
    [sceneSessionManager.PiPControlType.HANG_UP_BUTTON, true],
    [sceneSessionManager.PiPControlType.CAMERA_SWITCH, true],
    [sceneSessionManager.PiPControlType.MICROPHONE_SWITCH, true],
  ]);

  aboutToAppear() {
    this.pipControlStatusInfoList = SCBPiPManager.getInstance().getTemplateInfo()?.pipControlStatusInfoList;
    this.pipControlEnableInfoList = SCBPiPManager.getInstance().getTemplateInfo()?.pipControlEnableInfoList;
    this.controlGroups = SCBPiPManager.getInstance().getTemplateInfo()?.controlGroup;
    this.initCallBacks();
    this.initControlStatus();
    if (this.controlGroups === undefined || this.controlGroups === null) {
      return;
    }
    this.controlNum = this.controlGroups.length;
    if (this.controlGroups.length === Constants.MAX_ICON_NUM) {
      this.spaceIndex = 1;
    }
    // switch hangup icon to the middle position
    if (this.controlGroups.indexOf(Constants.MEETING_HANGUP) !== -1 &&
      this.controlGroups.length === Constants.MAX_ICON_NUM) {
      let hangUpIndex = this.controlGroups.indexOf(Constants.MEETING_HANGUP);
      this.controlGroups[hangUpIndex] = this.controlGroups[1];
      this.controlGroups[1] = Constants.MEETING_HANGUP;
      log.showInfo('switch hangup button to the middle position');
    }
  }

  @Builder
  micButtonBuilder() {
    Button({ type: ButtonType.Circle }) {
      Image(this.isMic ? $r('sys.media.ohos_ic_public_voice') : $r('sys.media.ohos_ic_public_voice_off'))
        .size({
          width: Constants.DEFAULT_BIG_IMAGE_SIZE * Constants.SIZE_ARRAY[this.sizeIndex],
          height: Constants.DEFAULT_BIG_IMAGE_SIZE * Constants.SIZE_ARRAY[this.sizeIndex]
        })
        .fillColor($r('app.color.pip_icon_color'))
        .objectFit(ImageFit.Contain)
    }
    .size({
      width: Constants.DEFAULT_BIG_BUTTON_SIZE * Constants.SIZE_ARRAY[this.sizeIndex],
      height: Constants.DEFAULT_BIG_BUTTON_SIZE * Constants.SIZE_ARRAY[this.sizeIndex]
    })
    .backgroundColor($r('sys.color.ohos_id_color_floating_button_icon'))
    .enabled(this.controlEnableMap.get(sceneSessionManager.PiPControlType.MICROPHONE_SWITCH))
    .attributeModifier(Constants.OVERLAY_BUTTON_MODIFIER)
    .animation({ curve: Constants.OVERLAY_BUTTON_CLICK_EFFECT_CURVE })
    .onClick(() => {
      this.hideControlDelay = true;
      this.isMic = !this.isMic;
      SCBPiPManager.getInstance().sendActionControlEvent(Constants.MIC_STATE_CHANGE, this.isMic ?
        Constants.ACTION_STATUS_ON : Constants.ACTION_STATUS_OFF);
      SCBPiPManager.getInstance().sendControlEvent(sceneSessionManager.PiPControlType.MICROPHONE_SWITCH, this.isMic ?
        sceneSessionManager.PiPControlStatus.OPEN : sceneSessionManager.PiPControlStatus.CLOSE);
    })
  }

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
      case sceneSessionManager.PiPControlType.MUTE_SWITCH:
        this.isMute = controlStatus;
        break;
      case sceneSessionManager.PiPControlType.CAMERA_SWITCH:
        this.isCamera = controlStatus
        break;
      case sceneSessionManager.PiPControlType.MICROPHONE_SWITCH:
        this.isMic = controlStatus;
        break;
      default:
        log.showInfo(`controlType is invalid`);
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

  @Builder
  muteButtonBuilder() {
    Button({ type: ButtonType.Circle }) {
      Image(this.isMute ? $r('sys.media.ohos_ic_public_sound') : $r('sys.media.ohos_ic_public_sound_off'))
        .size({
          width: Constants.DEFAULT_BIG_IMAGE_SIZE * Constants.SIZE_ARRAY[this.sizeIndex],
          height: Constants.DEFAULT_BIG_IMAGE_SIZE * Constants.SIZE_ARRAY[this.sizeIndex]
        })
        .fillColor($r('app.color.pip_icon_color'))
        .objectFit(ImageFit.Contain)
    }
    .size({
      width: Constants.DEFAULT_BIG_BUTTON_SIZE * Constants.SIZE_ARRAY[this.sizeIndex],
      height: Constants.DEFAULT_BIG_BUTTON_SIZE * Constants.SIZE_ARRAY[this.sizeIndex]
    })
    .backgroundColor($r('sys.color.ohos_id_color_floating_button_icon'))
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
  hangupButtonBuilder() {
    Button({ type: ButtonType.Circle }) {
      Image($r('sys.media.ohos_ic_public_hang_up'))
        .size({
          width: Constants.DEFAULT_BIG_IMAGE_SIZE * Constants.SIZE_ARRAY[this.sizeIndex],
          height: Constants.DEFAULT_BIG_IMAGE_SIZE * Constants.SIZE_ARRAY[this.sizeIndex]
        })
        .fillColor($r('sys.color.ohos_id_color_primary_contrary'))
        .objectFit(ImageFit.Contain)
    }
    .size({
      width: Constants.DEFAULT_BIG_BUTTON_SIZE * Constants.SIZE_ARRAY[this.sizeIndex],
      height: Constants.DEFAULT_BIG_BUTTON_SIZE * Constants.SIZE_ARRAY[this.sizeIndex]
    })
    .backgroundColor($r('sys.color.ohos_id_color_handup'))
    .enabled(this.controlEnableMap.get(sceneSessionManager.PiPControlType.HANG_UP_BUTTON))
    .attributeModifier(Constants.OVERLAY_BUTTON_MODIFIER)
    .animation({ curve: Constants.OVERLAY_BUTTON_CLICK_EFFECT_CURVE })
    .onClick(() => {
      this.hideControlDelay = true;
      SCBPiPManager.getInstance().sendActionControlEvent(Constants.HANG_UP, Constants.ACTION_STATUS_UNDEFINED);
      SCBPiPManager.getInstance().sendControlEvent(sceneSessionManager.PiPControlType.HANG_UP_BUTTON,
        Constants.ACTION_STATUS_UNDEFINED);
    })
  }

  @Builder
  cameraButtonBuilder() {
    Button({ type: ButtonType.Circle }) {
      Image(this.isCamera ? $r('sys.media.ohos_ic_public_video') : $r('sys.media.ohos_ic_public_video_off'))
        .size({
          width: Constants.DEFAULT_BIG_IMAGE_SIZE * Constants.SIZE_ARRAY[this.sizeIndex],
          height: Constants.DEFAULT_BIG_IMAGE_SIZE * Constants.SIZE_ARRAY[this.sizeIndex]
        })
        .fillColor($r('app.color.pip_icon_color'))
        .objectFit(ImageFit.Contain)
    }
    .size({
      width: Constants.DEFAULT_BIG_BUTTON_SIZE * Constants.SIZE_ARRAY[this.sizeIndex],
      height: Constants.DEFAULT_BIG_BUTTON_SIZE * Constants.SIZE_ARRAY[this.sizeIndex]
    })
    .backgroundColor($r('sys.color.ohos_id_color_floating_button_icon'))
    .enabled(this.controlEnableMap.get(sceneSessionManager.PiPControlType.CAMERA_SWITCH))
    .attributeModifier(Constants.OVERLAY_BUTTON_MODIFIER)
    .animation({ curve: Constants.OVERLAY_BUTTON_CLICK_EFFECT_CURVE })
    .onClick(() => {
      this.hideControlDelay = true;
      this.isCamera = !this.isCamera;
      SCBPiPManager.getInstance().sendActionControlEvent(Constants.VIDEO_STATE_CHANGE, this.isCamera ?
        Constants.ACTION_STATUS_ON : Constants.ACTION_STATUS_OFF);
      SCBPiPManager.getInstance().sendControlEvent(sceneSessionManager.PiPControlType.CAMERA_SWITCH, this.isCamera ?
        sceneSessionManager.PiPControlStatus.OPEN : sceneSessionManager.PiPControlStatus.CLOSE);
    })
  }

  @Builder
  buttonGroupBuilder() {
    ForEach(this.controlGroups, (item: number) => {
      if (item === Constants.MEETING_MICROPHONE_SWITCH) {
        this.micButtonBuilder();
      }
      if (item === Constants.MEETING_HANGUP) {
        this.hangupButtonBuilder();
      }
      if (item === Constants.MEETING_CAMERA_SWITCH) {
        this.cameraButtonBuilder()
      }
      if (item === Constants.MEETING_MUTE_SWITCH) {
        this.muteButtonBuilder()
      }
    }, (item: string) => item)
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Row({ space: Constants.ITEM_SPACE[this.spaceIndex][this.sizeIndex] }) {
        this.buttonGroupBuilder();
      }
      .size({ width: '100%', height: Constants.DEFAULT_BIG_BUTTON_SIZE * Constants.SIZE_ARRAY[this.sizeIndex] })
      .justifyContent(FlexAlign.Center)
    }
    .size({ width: '100%', height: Constants.DEFAULT_GRADIENT_HEIGHT })
    .padding({ bottom: Constants.BOTTOM_PADDING_ARRAY[this.sizeIndex] })
    .linearGradient({
      angle: 0,
      colors: [['#4D000000', 0.0], ['#00000000', this.enableLinearGradient ? 1.0 : 0.0]]
    })
    .alignRules({
      bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
      left: { anchor: '__container__', align: HorizontalAlign.Start }
    })
    .onAreaChange((oldValue: Area, newValue: Area) => {
      if (oldValue.width === newValue.width) {
        return;
      }
      if (this.controlNum < 1 || this.controlNum > Constants.MAX_ICON_NUM) {
        return;
      }
      this.sizeIndex = newValue.width >= Constants.LARGE_ICON_PIP_WIDTH_MINIMUM[this.controlNum - 1] ? 1 : 0;
    })
    .hitTestBehavior(HitTestMode.Transparent)
    .id('meeting_control')
  }
}