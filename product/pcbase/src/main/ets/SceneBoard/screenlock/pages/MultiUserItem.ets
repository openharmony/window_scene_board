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

import { LogDomain, LogHelper, Trace } from '@ohos/basicutils';
import { sSettingsUtil, HiDfxEventUtil } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import ScreenLockService from '../refactor/ScreenLockService';
import { IUserData } from '@ohos/screenlockcommon';
import { KeyCode } from '@kit.InputKit';
import Constants from '../common/Constants';
import LockScreenAnimationController from '../common/LockScreenAnimationController';
import { AccountsComponentStyle } from '../common/StyleConfiguration';
import accountModel from '../refactor/AccountsModel';
import UserIcon from './UserIcon';
import AccountsViewModel from '../vm/AccountsViewModel';
import { CommonStyle } from '../style/CommonStyle';
import { UserStyle } from '../style/UserStyle';
import { PCUtils } from '../../../common/utils/PCUtils';
import { DomainSlot } from '../component/DomainSlot';
import {
  MultiSpaceSwitchOneGoCtrl,
  SwitchEnterpriseMultiSpaceType
} from '../../../common/EnterpriseMultiSpaceController';
import promptAction from '@ohos.promptAction';
import { systemParameterEnhance } from '@kit.BasicServicesKit';
import { SwitchAccountAnimationMethod } from './SwitchAccountAnimation';

const TAG = 'ScreenLock-MultiUserItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const loadingTime: number = 10000;
// 双空间下第一个用户为企业用户
const FIRST_USER_ID: number = 100;
const SWIPE_DIRECTION: number = 2;

@Component
export struct MultiUserItem {
  @Prop userItem: IUserData;
  @StorageLink('isScreenOn') isBuildEmoji: boolean = ScreenLockService.isScreenOn;
  @StorageLink('mCurrentUserId') mCurrentUserId: number = 0;
  @State isHovered: boolean = false;
  @State logIsLimiting: boolean = false;
  @State developerMode: boolean = false;
  @Link selectedUserID: number | undefined;
  @Link userNameMaxLength: number;
  @Consume isPowerMenuPanelShowed: boolean;
  @StorageLink('systemLanguage') systemLanguage: string = Constants.SYSTEM_LANGUAGE_CHINESE;
  @State commonStyle: CommonStyle = CommonStyle.getInstance();
  @State userStyle: UserStyle = UserStyle.getInstance();
  private accountsStyle: AccountsComponentStyle | null = null;
  private index: number = -1;

  private isBuildIcon(): boolean {
    // 提前buildIcon中的Emoji头像会导致屏幕显示时emoji的表情异常，故需要在合适的时机buildEmoji
    log.showInfo(`buildIcon: ${this.isBuildEmoji}`);
    return this.isBuildEmoji;
  }

  private getBackgroundColor(): ResourceColor {
    if (this.isHovered) {
      return this.userStyle.style.multiUserItemHoverBgColor;
    }
    return this.commonStyle.clearColor;
  }

  private getBackgroundBlur(): number {
    if (this.isHovered) {
      return this.userStyle.style.multiUserItemHoverBgBlur;
    }
    return this.commonStyle.style.clearRadius;
  }

  private getBackgroundSaturation(): number {
    if (this.isHovered) {
      return this.userStyle.style.multiUserItemHoverBgSaturation;
    }
    return this.commonStyle.style.clearSaturation;
  }

  private isDeveloperMode(): boolean {
    try {
      const isDevelopMode: boolean = systemParameterEnhance.getSync('const.security.developermode.state', 'false') === 'true';
      log.showInfo(`current developmode is ${isDevelopMode}`);
      return isDevelopMode;
    } catch (error) {
      log.showError(`getSync unexpected error:${error}`);
      return false;
    }
  }

  private accountClick(): void {
    log.showInfo(`accountClick - isLoggedIn:${this.userItem?.isLoggedIn}`);
    // 点击切换，如果有密码，则显示单用户，否则直接跳转
    if (!this.userItem?.userId) {
      log.showError('invalid userItem');
      return;
    }
    if (!this.userItem.isLoggedIn && AccountsViewModel.getInstance().isNeedLimitLogging()) {
      if (this.isDeveloperMode()) {
        this.developerMode = true;
      } else {
        this.logIsLimiting = true;
      }
      return;
    }
    if (this.userItem.userId !== accountModel.getCurrentUserId()) {
      if (SwitchAccountAnimationMethod.enableEnterpriseSpace()) {
        if (MultiSpaceSwitchOneGoCtrl.get()
          .canHandleSpaceSwitch(SWIPE_DIRECTION, SwitchEnterpriseMultiSpaceType.HOVER_SCREEN_LOCK)) {
          MultiSpaceSwitchOneGoCtrl.get().handle(SWIPE_DIRECTION, SwitchEnterpriseMultiSpaceType.HOVER_SCREEN_LOCK);
          log.showInfo(`MultiSpaceSwitch switch success.`);
        }
      } else {
        log.showInfo(`CurrentUserId:${accountModel.getCurrentUserId()}`);
        accountModel.onUserSwitch(this.userItem.userId, loadingTime);
      }
    }
    if (SwitchAccountAnimationMethod.enableEnterpriseSpace()) {
      setTimeout((): void => this.updateSelectedUserId(this.userItem.userId), 200);
    } else {
      this.updateSelectedUserId(this.userItem.userId);
    }
  }

  private updateSelectedUserId(userId: number) {
    this.selectedUserID = userId;
    AccountsViewModel.getInstance().selectedUserId = this.userItem.userId;
    sSettingsUtil.setValue(Constants.IS_SHOULD_UNLOCK, 'true')
    sSettingsUtil.setValue(Constants.CHECK_USER_ID, this.userItem?.userId.toString())
  }

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear systemLanguage:${this.systemLanguage}`);
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
  }

  @Styles
  public normalStyle(): void {
    .border({
      color: this.commonStyle.clearColor,
      width: this.commonStyle.hoverBorderCommonWidth,
      radius: this.accountsStyle?.itemRadius
    })
    .backgroundColor(this.getBackgroundColor())
  }

  @Styles
  public focusedStyle(): void {
    .border({
      color: $r('sys.color.ohos_id_color_focused_outline'),
      width: this.commonStyle.hoverBorderCommonWidth,
      radius: this.accountsStyle?.itemRadius
    })
  }

  @Styles
  public pressedStyle(): void {
    .border({
      color: this.commonStyle.clearColor,
      width: this.commonStyle.hoverBorderCommonWidth,
      radius: this.accountsStyle?.itemRadius
    })
    .backgroundColor(this.userStyle.style.multiUserItemPressedBgColor)
  }

  @Builder
  accountIcon() {
    Stack({ alignContent: Alignment.BottomEnd }) {
      if (this.isBuildIcon()) {
        UserIcon({
          currentUserId: this.userItem?.userId,
          accountsStyle: this.accountsStyle
        })
      }

      if (this.userItem?.isLoggedIn) {
        Stack() {
          Circle()
            .width(this.userStyle.style.loggedIconWidth)
            .height(this.userStyle.style.loggedIconWidth)
            .fill(this.userStyle.style.loggedIconColor)
            .stroke(this.commonStyle.style.colorWhite20)
            .strokeWidth(this.commonStyle.style.borderWidth)
            .outline({
              width: this.commonStyle.style.borderWidth,
              color: this.commonStyle.style.colorBlack15,
              radius: this.userStyle.style.loggedIconWidth
            })
            .backgroundColor(this.commonStyle.style.colorWhite10)
            .borderRadius(this.userStyle.style.loggedIconWidth)
            .brightness(ResUtils.getNumber(this.userStyle.style.loggedIconBrightness))
        }
        .margin({ right: 6 })
        .width(20)
        .height(20)
        .borderRadius(10)
        .clip(false)
      }
    }
    .margin({ left: this.accountsStyle?.userIconMarginLeft })
    .width(this.accountsStyle?.userIconWidth)
    .height(this.accountsStyle?.userIconHeight)
  }

  @Builder
  accountName() {
    Text(!!this.userItem ? this.userItem.userName : 'default').draggable(false)
      .font({
        family: 'HarmonyOS-Sans-Digit,HarmonyOS-Sans',
        weight: FontWeight.Bold,
        size: this.accountsStyle?.userNameFontSize
      })
      .lineHeight(this.accountsStyle?.userNameLineHeight)
      .fontColor(this.userStyle.style.userNameColor)
      .maxLines(this.logIsLimiting ? 1 : 2)
      .textOverflow({
        overflow: TextOverflow.Ellipsis
      })
      .wordBreak(WordBreak.BREAK_ALL)
      .textAlign(TextAlign.Start)
      .textShadow(this.userStyle.style.userNameShadows)
      .clip(false)
      .onAreaChange((oldArea, newArea) => {
        if (this.index % 2 === 0) {
          const nameWidth: number = parseFloat(newArea.width.toString());
          this.userNameMaxLength = Math.max(this.userNameMaxLength, nameWidth);
          log.showInfo(`width${nameWidth}, max:${this.userNameMaxLength}`);
        }
      })
  }

  @Builder
  enterpriseSpaceIcon() {
    Image($r('app.media.ic_Enterprise'))
      .id('enterpriseIcon')
      .size({ width: 20, height: 20 })
      .align(Alignment.Start)
      .clip(false)
      .margin({
        bottom: $r('app.float.common_margin3'),
        right: $r('app.float.common_margin5')
      })
  }

  @Builder
  errorPrompts() {
    Text($r('app.string.user_log_limiting_prompt'))
      .font({
        family: 'HarmonyHeiTi',
        weight: FontWeight.Medium,
        size: this.accountsStyle?.errorPromptFontSize
      })
      .fontColor(this.userStyle.style.loggingLimitColor)
      .lineHeight(this.accountsStyle?.errorPromptLineHeight)
      .textAlign(TextAlign.Start)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .textShadow(this.userStyle.style.loggingLimitTextShadow)
  }

  private showUsersNumLimitToast(): void {
    if (this.logIsLimiting) {
      try {
        promptAction.showToast({
          message: $r('app.string.account_limit_toast'),
          duration: 1500,
          showMode: promptAction.ToastShowMode.SYSTEM_TOP_MOST,
        });
      } catch (error) {
        log.showError(`showToast error is ${error}`);
      }
    }
  }

  private showDeveloperModeLimitToast(): void {
    if (this.developerMode) {
      try {
        promptAction.showToast({
          message: $r('app.string.account_limit_developermode'),
          duration: 2000,
          showMode: promptAction.ToastShowMode.SYSTEM_TOP_MOST,
        });
      } catch (error) {
        log.showError(`showToast error is ${error}`);
      }
    }
  }

  build() {
    Row() {
      this.accountIcon()

      Column() {
        Flex({ alignItems: ItemAlign.Center }) {
          if (PCUtils.getIsEnterSpaceEnabled() && this.userItem?.userId == FIRST_USER_ID) {
            this.enterpriseSpaceIcon()
          }
          this.accountName()
          if (!PCUtils.getIsEnterSpaceEnabled() && this.userItem.isDomain) {
            DomainSlot({
              isHover: this.isHovered,
              textMarginLeft: this.userStyle.domainSlotTextMarginLeft,
              iconMarginLeft: this.userStyle.domainSlotIconMarginLeft,
              marginBottom: this.commonStyle.defaultLength,
            })
          }
        }
        .constraintSize({ maxWidth: 202 })
      }
      .margin({ left: this.accountsStyle?.userNameMarginLeft })
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Start)
    }
    .alignItems(VerticalAlign.Center)
    .onClick(() => {
      this.accountClick();
      AppStorage.setOrCreate('isPwdVisibleForPC', true);
      this.showDeveloperModeLimitToast();
      this.showUsersNumLimitToast();
    })
    .onTouch((event: TouchEvent) => {
      event.stopPropagation();
      this.isPowerMenuPanelShowed = false;
    })
    .focusable(!this.isPowerMenuPanelShowed)
    .onHover((isHovered) => {
      this.isHovered = isHovered;
    })
    .stateStyles({
      normal: this.normalStyle,
      focused: this.focusedStyle,
      pressed: this.pressedStyle
    })
    .borderRadius(this.accountsStyle?.itemRadius)
    .backgroundEffect({ radius: this.getBackgroundBlur() })
    .saturate(this.getBackgroundSaturation())
    .width(this.accountsStyle?.itemWidth)
    .height(this.accountsStyle?.itemHeight)
  }
}