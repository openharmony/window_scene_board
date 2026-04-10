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
import { IUserData } from '@ohos/screenlockcommon';
import accountModel from '../refactor/AccountsModel';
import { SCBFoldState } from '@ohos/statusbarcomponent/src/main/ets/pc/utils/enum';
import StyleConfiguration from '../common/StyleConfiguration';
import { AccountsComponentStyle } from '../common/StyleConfiguration';
import UserIcon from './UserIcon';

const TAG = 'ScreenLock-UserSwitchLoading'

const COMPONENT_ID_NAME = TAG + '_Text_name';
const COMPONENT_ID_LOADING = TAG + '_Loading';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

@Preview
@Component
export default struct UserSwitchLoading {
  @StorageLink('isScreenLockWallpaperBrightOrDark') isBrightOrDark: boolean = true;
  private accountsStyle: AccountsComponentStyle | null = StyleConfiguration.getAccountsComponentStyle();
  private selectUser: IUserData | undefined = accountModel.getUserData();
  @State heightPercent: Length = '100%';

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    this.initHeightPercent();
  }

  private initHeightPercent(): void {
    this.heightPercent = '100%';
  }

  build() {
    Column() {
      UserIcon({
        currentUserId: this.selectUser?.userId,
        accountsStyle: this.accountsStyle
      })
        .borderRadius($r('app.float.screenLock_unselect_user_layout_border_radius'))
        .backgroundColor($r('app.color.transparent'))
        .backgroundBlurStyle(BlurStyle.BACKGROUND_THICK, {
          colorMode: ThemeColorMode.DARK,
          adaptiveColor: AdaptiveColor.AVERAGE,
          policy: 1
        })
        .sharedTransition(this.selectUser?.userName, { duration: 400, curve: Curve.Linear })

      Blank()
        .height(18)

      Text(this.selectUser?.userName)
        .draggable(false)
        .id(COMPONENT_ID_NAME)
        .fontSize($r('app.float.screenLock_user_name_font_size'))
        .maxLines(1)
        .width(226)
        .wordBreak(WordBreak.BREAK_ALL)
        .textAlign(TextAlign.Center)
        .fontWeight(FontWeight.Medium)
        .fontFamily($r('app.float.pwd_prompt_font_family'))
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .fontColor($r('app.color.text_color'))
        .backgroundColor($r('app.color.transparent'))
        .textShadow({
          offsetY: $r('app.float.screenLock_user_name_shadow_offset_y'),
          color: $r('app.color.user_name_shadow_color'),
          radius: $r('app.float.screenLock_user_name_shadow_radio')
        })
        .sharedTransition(this.selectUser?.userName + '_text', { duration: 400, curve: Curve.Linear })

      LoadingProgress()
        .id(COMPONENT_ID_LOADING)
        .color(Color.White)
        .width(72)
        .height(72)
        .margin({ top: '32vp' })
    }
    .id('UserSwitchLoading')
    .backgroundColor($r('app.color.transparent'))
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height(this.heightPercent)
    .position({
      y: 0
    })
  }
}