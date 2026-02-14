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

import curves from '@ohos.curves';
import { PipTemplate, Constants } from '../utils/PictureInPictureConstants';
import { DefaultControlPanel } from './DefaultControlPanel';
import { LiveControlPanel } from './LiveControlPanel';
import { VideoCallControlPanel } from './VideoCallControlPanel';
import { VideoMeetingControlPanel } from './VideoMeetingControlPanel';
import { VideoPlayControlPanel } from './VideoPlayControlPanel';
import { LogDomain, LogHelper, CommonUtils } from '@ohos/basicutils';
import { AccessibilityManager } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import { SCBPiPManager } from '../SCBPiPManager';

const TIMEOUT: number = 3000;
const SHOW_LINEAR_GRADIENT = 48;
const SHOW_LIVE_ICON_MINIMUM = 56;

const TAG = 'PiPOverlay';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

@Component
export struct PiPOverlay {
  private hideEventId: number = -1;
  private controlTransEffect: TransitionEffect = TransitionEffect.OPACITY;
  private onActionMoveStart = (event: GestureEvent) => {};
  private onActionMove = (event: GestureEvent) => {};
  private onActionMoveEnd = (event?: GestureEvent) => {};
  private onDoubleClick = () => {};
  private onActionClose = () => {};
  private onActionRestore = () => {};

  @State controlNum: number = 0;
  @State sizeIndex: number = 0;
  @State private showControl: boolean = false;
  @State private showLiveIcon: boolean = true;
  @State private showCallandMeetingIcon: boolean = true;
  @Prop radius: number = 0;
  @Provide @Watch('onHideControlDelay') hideControlDelay: boolean = false;
  @Provide enableLinearGradient: boolean = true;

  aboutToAppear(): void {
    if (CommonUtils.isInvalid(SCBPiPManager.getInstance().getControlGroups())) {
      return;
    }
    log.showInfo(`templateInfo.controlGroup ${SCBPiPManager.getInstance().getControlGroups()}`);
    this.controlNum = SCBPiPManager.getInstance().getControlGroups().length;
  }

  isShowCallOrMeetingControl(newValue: Area) {
    if (this.controlNum < 1 || this.controlNum > Constants.MAX_ICON_NUM) {
      return;
    }
    this.sizeIndex = newValue.width >= Constants.LARGE_ICON_PIP_WIDTH_MINIMUM[this.controlNum - 1] ? 1 : 0;
    if (newValue.height < (Constants.DEFAULT_BIG_BUTTON_SIZE * Constants.SIZE_ARRAY[this.sizeIndex] +
    Constants.BOTTOM_PADDING_ARRAY[this.sizeIndex]) ) {
      log.showInfo(`pip window height is not enough,do not show call or meeting panel`);
      this.showCallandMeetingIcon = false;
    } else {
      this.showCallandMeetingIcon = true;
    }
  }

  onAreaChangeAction = (oldValue: Area, newValue: Area) => {
    this.isShowCallOrMeetingControl(newValue);
    if (newValue.height <= SHOW_LINEAR_GRADIENT) {
      this.enableLinearGradient = false;
    } else {
      this.enableLinearGradient = true;
    }
    if (newValue.height < SHOW_LIVE_ICON_MINIMUM) {
      log.showInfo(`pip window height is not enough,do not show live panel`);
      this.showLiveIcon = false;
    } else {
      this.showLiveIcon = true;
    }
  }

  onHideControlDelay() {
    if (this.hideControlDelay) {
      this.delayHide();
    }
    this.hideControlDelay = false;
  }

  switchToShow() {
    if (SCBPiPManager.getInstance().isPipShowAnimating) {
      return;
    }
    animateTo({ curve: curves.responsiveSpringMotion(0.25, 1) }, () => {
      this.showControl = true;
    });
    SCBPiPManager.getInstance().sendAccessibilityEvent(ResUtils.getInnerString($r('app.string.pip_window_open')));
    if (!SCBPiPManager.getInstance().isAccessibilityMode()) {
      this.delayHide();
    }
  }

  switchToHide() {
    if (this.hideEventId !== -1) {
      clearTimeout(this.hideEventId);
    }
    animateTo({ curve: curves.responsiveSpringMotion(0.25, 1) }, () => {
      this.showControl = false;
    });
    SCBPiPManager.getInstance().sendAccessibilityEvent(ResUtils.getInnerString($r('app.string.pip_window_close')));
  }

  switchToHideWithoutAnime() {
    if (this.hideEventId !== -1) {
      clearTimeout(this.hideEventId);
    }
    this.showControl = false;
  }

  delayHide() {
    if (this.hideEventId !== -1) {
      clearTimeout(this.hideEventId);
    }
    this.hideEventId = this.showControl ?
    setTimeout(() => {
      animateTo({ curve: curves.responsiveSpringMotion(0.25, 1) }, () => {
        this.showControl = false;
      });
    }, TIMEOUT) : -1;
  }

  @Builder realControlPanelBuilder() {
    RelativeContainer() {
      if (SCBPiPManager.getInstance().isDefaultControlVisible()) {
        DefaultControlPanel({
          onActionClose: this.onActionClose,
          onActionRestore: this.onActionRestore
        });
      }
      if (SCBPiPManager.getInstance().getTemplateType() === PipTemplate.TYPE_VIDEO_PLAY) {
        VideoPlayControlPanel();
      } else if (SCBPiPManager.getInstance().getTemplateType() === PipTemplate.TYPE_VIDEO_CALL &&
        this.showCallandMeetingIcon) {
        VideoCallControlPanel();
      } else if (SCBPiPManager.getInstance().getTemplateType() === PipTemplate.TYPE_VIDEO_MEETING &&
        this.showCallandMeetingIcon) {
        VideoMeetingControlPanel();
      } else if (SCBPiPManager.getInstance().getTemplateType() === PipTemplate.TYPE_LIVE && this.showLiveIcon) {
        LiveControlPanel();
      }
    }
    .visibility(this.showControl ? Visibility.Visible : Visibility.Hidden)
    .hitTestBehavior(this.showControl ? HitTestMode.Default : HitTestMode.None)
    .size({ width: '100%', height: '100%' })
    .transition(this.controlTransEffect)
    .onAreaChange(this.onAreaChangeAction)
    .alignRules({
      top: { anchor: '__container__', align: VerticalAlign.Top },
      right: { anchor: '__container__', align: HorizontalAlign.End }
    })
    .id('control_inner')
  }

  private onTapGestureAction(): void {
    if (!SCBPiPManager.getInstance().isDefaultControlVisible()) {
      this.onActionRestore();
      return;
    }
    if (this.showControl) {
      this.switchToHide();
    } else {
      this.switchToShow();
    }
  }

  private onPanGestureActionStart(event: GestureEvent): void {
    this.showControl = false;
    if (event !== null && event !== undefined) {
      this.onActionMoveStart(event);
    }
  }

  build() {
    RelativeContainer() {
      Stack()
        .size({ width: '100%', height: '100%' })
        .id('fill_stack')
      this.realControlPanelBuilder();
    }
    .size({ width: '100%', height: '100%' })
    .id('control')
    .onHover(() => {
      this.switchToShow();
    })
    .accessibilityText(ResUtils.getInnerString($r('app.string.pip_video_player')))
    .gesture(
      GestureGroup(GestureMode.Exclusive,
        TapGesture({ count: 2 })
          .onAction((event: GestureEvent) => {
            this.switchToHideWithoutAnime();
            this.onDoubleClick();
          }),
        TapGesture({ count: 1 })
          .onAction((event: GestureEvent) => {
            this.onTapGestureAction();
          }),
        PanGesture({distance: 1})
          .onActionStart((event) => {
            this.onPanGestureActionStart(event);
          })
          .onActionUpdate((event) => {
            if (event !== null && event !== undefined) {
              this.onActionMove(event);
            }
          })
          .onActionEnd((event) => {
            this.onActionMoveEnd(event);
          })
          .onActionCancel(() => {
            this.onActionMoveEnd();
          })
      )
    )
  }
}