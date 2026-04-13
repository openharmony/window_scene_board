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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import KeyBoardLayoutConstants from '../../common/LayoutConstants';
import { KeyGuardMode, SLWallpaperState
} from '@ohos/screenlockcommon';
import { IDHelperUtil } from '@ohos/screenlockcommon/Index';
import { ScreenLockPasswordVm } from '../viewmodel/PasswordVm'
import { PasswordManager, PasswordChangeListener } from '@ohos/screenlockcommon/src/main/ets/manager/PasswordManager';
import { slWallpaperMgr } from '@ohos/screenlockcommon';
import { sFontScaleUtil } from '@ohos/screenlockwidget/src/main/ets/common/utils/FontScaleUtil';
import { GlobalStatusCache, StatusCacheConst } from '@ohos/screenlockcommon/src/main/ets/base/GlobalStatusCache';
import { PasswordLayoutConfig } from '../common/PasswordLayoutConfig';
import { KeyCode } from '@kit.InputKit';
import { SpecialModeManager, SpecialModeViewData } from '../../common/SpecialModeManager';

const TAG = 'NumberPasswordInput';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

@Component
export default struct NumberPasswordInput {
  private passwordVm?: ScreenLockPasswordVm;
  private numberShowTimeId: number = -1;
  private scroller: Scroller = new Scroller();
  private onEnterClick: Function = () => {};
  private inputAccessText?: Resource;
  @State password: string[] = [];
  @State isEndNumberShow: boolean = false;
  @State enterIconPress: boolean = false;
  @State slWallpaperState: SLWallpaperState = slWallpaperMgr.getSlWallpaperState();
  @Prop inputWidth: number = 0;
  @Prop isShowEnter: boolean = true;
  @Prop inputHeight: Resource;
  @Consume passwordLayoutConfig: PasswordLayoutConfig;
  @State specialModeViewData: SpecialModeViewData = SpecialModeManager.getInstance().getSpecialModeViewData();
  private passwordChangeListener: PasswordChangeListener = {
    onPasswordChange: (isAdd: boolean, passwordLength: number): void => {
      this.password = this.passwordVm?.password ?? [];
      clearTimeout(this.numberShowTimeId);
      this.isEndNumberShow = isAdd;
      if (isAdd) {
        this.numberShowTimeId = setTimeout(() => {
          this.isEndNumberShow = false;
        }, 1500);
      }
    }
  };

  aboutToAppear() {
    log.showInfo('aboutToAppear');
    PasswordManager.getInstance().registerObserver(this.passwordChangeListener);
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
    PasswordManager.getInstance().unRegisterObserver(this.passwordChangeListener);
  }

  @Builder
  inputIconBuilder() {
    Row() {
      /*Row() {
        Image($r('app.media.ic_public_enter'))
          .width($r('app.float.pwd_contacts_group_height'))
          .height($r('app.float.pwd_contacts_group_height'))
          .fillColor(this.slWallpaperState?.getWallpaperReverseColor())
          .objectFit(ImageFit.Contain)
          .accessibilityLevel('no')
          .draggable(false)
          .matchTextDirection(true)
      }
      .draggable(false)
      .id(IDHelperUtil.getImageId(TAG, 'enter'))
      .margin(this.enterIconMargin())
      .visibility(this.isShowEnter ? Visibility.Visible : Visibility.None)
      .opacity(this.enterIconOpacity())
      .enabled(!this.passwordVm?.disableInput)
      .onTouch((event: TouchEvent) => {
        log.showInfo('enter onTouch')
        if (event?.type == TouchType.Down) {
          this.enterIconPress = true;
        } else if (event?.type == TouchType.Up) {
          this.enterIconPress = false;
        }
        if (event?.stopPropagation) {
          event.stopPropagation();
        }
      })
      .onClick((event?: ClickEvent) => {
        this.onEnterClick();
      })
      .onKeyEvent((event?: KeyEvent) => {
        if (event?.type === KeyType.Up &&
          (event?.keyCode === KeyCode.KEYCODE_ENTER || event?.keyCode === KeyCode.KEYCODE_NUMPAD_ENTER)) {
          this.onEnterClick();
        }
      })
      .accessibilityGroup(true)
      .accessibilityLevel('yes')
      .accessibilityDescription((this.passwordVm?.passwordLength == 0) ?
      ResUtils.getInnerString($r('app.string.access_unavailable')) : '')
      .accessibilityRole(AccessibilityRoleType.BUTTON)
      .accessibilityText(ResUtils.getInnerString($r('app.string.sim_card_psd_confirm_accessible')))*/
    }
    .backgroundColor(this.enterIconColor())
    .justifyContent(FlexAlign.End)
    .alignItems(VerticalAlign.Center)
    .width(this.inputWidth)
    .height(this.inputHeight)
    .border({
      radius: $r('app.float.pwd_input_row_border_radius'),
      style: BorderStyle.Solid,
      color: this.enterIconColor()
    })
    .backdropBlur(50, undefined, { disableSystemAdaptation: true })
  }

  @Builder
  passwdDisplayBuilder() {
    Scroll(this.scroller) {
      Row({}) {
        ForEach(this.password, (item: Resource, index: number) => {
          if (index === this.password.length - 1 && this.isEndNumberShow) {
            Text(this.password[index].toString())
              .draggable(false)
              .fontSize(16)
              .minFontScale(sFontScaleUtil.minFontSize)
              .maxFontScale(sFontScaleUtil.maxLockIconFontSize)
              .fontColor(this.slWallpaperState?.getWallpaperReverseColor())
              .margin({
                right: $r('app.float.imageitem_margin_right'),
                left: $r('app.float.imageitem_margin_left')
              })
              .onAppear(() => {
                this.scroller.scrollEdge(Edge.End);
              })
          } else {
            Image($r('app.media.ic_solid_dot'))
              .draggable(false)
              .id(IDHelperUtil.getImageId(TAG, 'solid_dot'))
              .width($r('app.float.custompwd_passwdmask_dot_width_height'))
              .height($r('app.float.custompwd_passwdmask_dot_width_height'))
              .fillColor(this.slWallpaperState?.getWallpaperReverseColor())
              .margin({
                right: $r('app.float.imageitem_margin_right'),
                left: $r('app.float.imageitem_margin_left')
              })
          }
        })
      }
      .backgroundColor($r('app.color.transparent'))
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .height(this.inputHeight)
      .border({
        radius: $r('app.float.pwd_input_row_border_radius')
      })
      .visibility(Visibility.Visible)
    }
    .scrollable(ScrollDirection.Horizontal)
    .enableScrollInteraction(false)
    .scrollBar(BarState.Off)
    .width(`${this.inputWidth - this.getScrollWidth()}vp`)
    .height(this.inputHeight)
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      this.inputIconBuilder();
      this.passwdDisplayBuilder();
    }
    .height(this.inputHeight)
    .accessibilityLevel('yes')
    .accessibilityText(this.inputAccessText)
  }

  private enterIconColor(): ResourceColor {
    let isSpecialModeBouncerFocus: boolean = this.specialModeViewData.curMode !== KeyGuardMode.DEFAULT;
    return isSpecialModeBouncerFocus || !this.slWallpaperState.isLightWallpaper ?
    $r('app.color.pwd_input_bg_color') : $r('app.color.pwd_input_bg_color_black')
  }

  private enterIconMargin(): Margin {
    return {
      right: this.passwordLayoutConfig.layoutConfig.simCardInputIconBackMarginRight,
      left: $r('app.float.phone_pwd_icon_back_magin_right')
    }
  }

  private enterIconOpacity(): number {
    return this.password.length <= 0 || this.passwordVm?.disableInput || this.enterIconPress ?
      0.38 : 1;
  }

  private getScrollWidth(): number {
    return this.passwordLayoutConfig.layoutConfig.outerScreenFlag ?
    KeyBoardLayoutConstants.OUTER_SCROLL_WIDTH_REDUCE : KeyBoardLayoutConstants.SCROLL_WIDTH_REDUCE;
  }

}