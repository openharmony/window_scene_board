/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { ResUtils } from '@ohos/windowscene'
import sceneSessionManager from '@ohos.sceneSessionManager';
import { SCBPiPManager } from '../SCBPiPManager';

const TAG = 'VideoPlayControlPanel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

const SHOW_ICON_BELOW_WIDTH = 100;
const SHOW_ICON_MIDDLE_WIDTH = 152;

@Component
export struct VideoPlayControlPanel {
  @State isPlaying: boolean = true;
  @State shouldShowNextAndPrev: boolean = true;
  @State horMargin: number = 12;
  @Consume hideControlDelay: boolean;
  @State private controlGroups?: number[] | undefined = [];
  @Consume enableLinearGradient: boolean;
  private pipControlStatusInfoList?: sceneSessionManager.PiPControlStatusInfo[] | undefined = [];
  private pipControlEnableInfoList?: sceneSessionManager.PiPControlEnableInfo[] | undefined = [];
  @State private controlEnableMap: Map<sceneSessionManager.PiPControlType, boolean> = new Map([
    [sceneSessionManager.PiPControlType.VIDEO_PLAY_PAUSE, true],
    [sceneSessionManager.PiPControlType.VIDEO_PREVIOUS, true],
    [sceneSessionManager.PiPControlType.VIDEO_NEXT, true],
    [sceneSessionManager.PiPControlType.FAST_FORWARD, true],
    [sceneSessionManager.PiPControlType.FAST_BACKWARD, true],
  ]);

  onAreaChangeAction = (oldValue: Area, newValue: Area) => {
    if (newValue.width < SHOW_ICON_BELOW_WIDTH) {
      this.shouldShowNextAndPrev = false;
    } else if (newValue.width < SHOW_ICON_MIDDLE_WIDTH) {
      this.horMargin = (newValue.width as number - SHOW_ICON_BELOW_WIDTH) / 4;
      this.shouldShowNextAndPrev = true;
    } else {
      this.horMargin = 12;
      this.shouldShowNextAndPrev = true;
    }
  }

  @Styles
  controlStyles() {
    .backgroundColor('#00FFFFFF')
    .size({ width: 24, height: 24 })
    .responseRegion({ x: '-50%', y: '-50%', width: '200%', height: '200%' })
  }

  @Builder leftControlBuilder(res: string, controlEvent: string, id: string,
    controlType: sceneSessionManager.PiPControlType) {
    Button({ type: ButtonType.Circle }) {
      Image($r(res))
        .fillColor($r('sys.color.ohos_id_color_primary_contrary'))
        .objectFit(ImageFit.Contain)
    }
    .controlStyles()
    .margin({ left: this.horMargin, right: this.horMargin * 2, top: 12, bottom: 12 })
    .visibility(this.shouldShowNextAndPrev ? Visibility.Visible : Visibility.None)
    .alignRules({
      center: { anchor: '__container__', align: VerticalAlign.Center },
      right: { anchor: 'control_play', align: HorizontalAlign.Start }
    })
    .id(id)
    .enabled(this.controlEnableMap.get(controlType))
    .attributeModifier(Constants.OVERLAY_BUTTON_MODIFIER)
    .animation({ curve: Constants.OVERLAY_BUTTON_CLICK_EFFECT_CURVE })
    .accessibilityText(this.voiceBroadcastLeftControl(controlType))
    .onClick(() => {
      if (!SCBPiPManager.getInstance().isAccessibilityMode()) {
        this.hideControlDelay = true;
      }
      SCBPiPManager.getInstance().sendActionControlEvent(controlEvent, Constants.ACTION_STATUS_UNDEFINED);
      SCBPiPManager.getInstance().sendControlEvent(controlType, Constants.ACTION_STATUS_UNDEFINED);
    })
  }

  @Builder middleControlBuilder() {
    Button({ type: ButtonType.Circle }) {
      Image(this.isPlaying ? $r('sys.media.ohos_ic_public_pause') : $r('sys.media.ohos_ic_public_play'))
        .fillColor($r('sys.color.ohos_id_color_primary_contrary'))
        .objectFit(ImageFit.Contain)
    }
    .controlStyles()
    .margin({ top: 12, bottom: 12 })
    .alignRules({
      center: { anchor: '__container__', align: VerticalAlign.Center },
      middle: { anchor: '__container__', align: HorizontalAlign.Center }
    })
    .id('control_play')
    .enabled(this.controlEnableMap.get(sceneSessionManager.PiPControlType.VIDEO_PLAY_PAUSE))
    .attributeModifier(Constants.OVERLAY_BUTTON_MODIFIER)
    .animation({ curve: Constants.OVERLAY_BUTTON_CLICK_EFFECT_CURVE })
    .accessibilityText(this.isPlaying ? ResUtils.getInnerString($r('app.string.pip_play_pause')) :
    ResUtils.getInnerString($r('app.string.pip_play')))
    .onClick(() => {
      this.isPlaying = !this.isPlaying;
      SCBPiPManager.getInstance().sendActionControlEvent(Constants.PLAY_BACK_STATE_CHANGE, this.isPlaying ?
      Constants.ACTION_STATUS_ON : Constants.ACTION_STATUS_OFF);
      SCBPiPManager.getInstance().sendControlEvent(sceneSessionManager.PiPControlType.VIDEO_PLAY_PAUSE,
        this.isPlaying ? sceneSessionManager.PiPControlStatus.PLAY : sceneSessionManager.PiPControlStatus.PAUSE);
      if (!SCBPiPManager.getInstance().isAccessibilityMode()) {
        this.hideControlDelay = true;
      }
    })
  }

  @Builder rightControlBuilder(res: string, controlEvent: string, id: string,
    controlType: sceneSessionManager.PiPControlType) {
    Button({ type: ButtonType.Circle }) {
      Image($r(res))
        .fillColor($r('sys.color.ohos_id_color_primary_contrary'))
        .objectFit(ImageFit.Contain)
    }
    .controlStyles()
    .margin({ left: this.horMargin * 2, right: this.horMargin, top: 12, bottom: 12 })
    .visibility(this.shouldShowNextAndPrev ? Visibility.Visible : Visibility.None)
    .alignRules({
      center: { anchor: '__container__', align: VerticalAlign.Center },
      left: { anchor: 'control_play', align: HorizontalAlign.End }
    })
    .id(id)
    .enabled(this.controlEnableMap.get(controlType))
    .attributeModifier(Constants.OVERLAY_BUTTON_MODIFIER)
    .animation({ curve: Constants.OVERLAY_BUTTON_CLICK_EFFECT_CURVE })
    .accessibilityText(this.voiceBroadcastRightControl(controlType))
    .onClick(() => {
      if (!SCBPiPManager.getInstance().isAccessibilityMode()) {
        this.hideControlDelay = true;
      }
      SCBPiPManager.getInstance().sendActionControlEvent(controlEvent, Constants.ACTION_STATUS_UNDEFINED);
      SCBPiPManager.getInstance().sendControlEvent(controlType, Constants.ACTION_STATUS_UNDEFINED);
    })
  }

  aboutToAppear(): void {
    this.pipControlStatusInfoList = SCBPiPManager.getInstance().getTemplateInfo()?.pipControlStatusInfoList;
    this.pipControlEnableInfoList = SCBPiPManager.getInstance().getTemplateInfo()?.pipControlEnableInfoList;
    this.controlGroups = SCBPiPManager.getInstance().getTemplateInfo()?.controlGroup;
    this.initCallBacks();
    this.initControlStatus();
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

  voiceBroadcastLeftControl(controlType: sceneSessionManager.PiPControlType): string | undefined {
    if (controlType === sceneSessionManager.PiPControlType.VIDEO_PREVIOUS) {
      return ResUtils.getInnerString($r('app.string.pip_play_previous'));
    }
    if (controlType === sceneSessionManager.PiPControlType.FAST_BACKWARD) {
      return ResUtils.getInnerString($r('app.string.pip_play_fast_backward'));
    }
    return;
  }

  voiceBroadcastRightControl(controlType: sceneSessionManager.PiPControlType): string | undefined {
    if (controlType === sceneSessionManager.PiPControlType.VIDEO_NEXT) {
      return ResUtils.getInnerString($r('app.string.pip_play_next'));
    }
    if (controlType === sceneSessionManager.PiPControlType.FAST_FORWARD) {
      return ResUtils.getInnerString($r('app.string.pip_play_fast_forward'));
    }
    return;
  }

  setControlStatus(controlType: sceneSessionManager.PiPControlType, status: sceneSessionManager.PiPControlStatus) {
    let controlStatus : boolean = true;
    if (status === sceneSessionManager.PiPControlStatus.PLAY) {
      controlStatus = true;
    } else if (status === sceneSessionManager.PiPControlStatus.PAUSE) {
      controlStatus = false;
    } else {
      log.showInfo('status is invalid');
      return;
    }
    switch (controlType) {
      case sceneSessionManager.PiPControlType.VIDEO_PLAY_PAUSE:
        this.isPlaying = controlStatus;
        break;
      default:
        log.showInfo('controlType is invalid');
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

  build() {
    RelativeContainer() {
      if (this.controlGroups?.indexOf(Constants.PREVIOUS_NEXT) !== -1) {
        this.leftControlBuilder('sys.media.ohos_ic_public_play_last', Constants.PREVIOUS_VIDEO, 'control_play_last',
          sceneSessionManager.PiPControlType.VIDEO_PREVIOUS);
      }
      if (this.controlGroups?.indexOf(Constants.FAST_FORWARD_BACKWARD) !== -1) {
        this.leftControlBuilder('app.media.ic_fast_backward', Constants.FAST_BACKWARD, 'control_fast_backward',
          sceneSessionManager.PiPControlType.FAST_BACKWARD);
      }
      this.middleControlBuilder();
      if (this.controlGroups?.indexOf(Constants.PREVIOUS_NEXT) !== -1) {
        this.rightControlBuilder('sys.media.ohos_ic_public_play_next', Constants.NEXT_VIDEO, 'control_play_next',
          sceneSessionManager.PiPControlType.VIDEO_NEXT);
      }
      if (this.controlGroups?.indexOf(Constants.FAST_FORWARD_BACKWARD) !== -1) {
        this.rightControlBuilder('app.media.ic_fast_forward', Constants.FAST_FORWARD, 'control_fast_forward',
          sceneSessionManager.PiPControlType.FAST_FORWARD);
      }
    }
    .width('100%')
    .height(48)
    .linearGradient({
      angle: 0,
      colors: [['#4D000000', 0.0], ['#00000000', this.enableLinearGradient ? 1.0 : 0.0]]
    })
    .onAreaChange(this.onAreaChangeAction)
    .alignRules({
      bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
      left: { anchor: '__container__', align: HorizontalAlign.Start }
    })
    .hitTestBehavior(HitTestMode.Transparent)
    .id('video_control')
  }
}
