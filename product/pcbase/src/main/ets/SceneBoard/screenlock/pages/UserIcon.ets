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
import { BootCompletedAnimationController } from '../common/BootCompletedAnimationController';
import Constants from '../common/Constants';
import { AccountsComponentStyle } from '../common/StyleConfiguration';
import { UserIconInfo, UserIconViewModel, IconImgType } from '../vm/UserIconViewModel';
import Emoji3dComponent from './Emoji3dComponent';
import EmojiComponent from './EmojiComponent';

const TAG = 'ScreenLock-UserIcon'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

@Component
export default struct UserIcon {
  @Prop @Watch('updateUserIconInfo') currentUserId: number = 0;
  private accountsStyle: AccountsComponentStyle | null = null;
  @State userIconInfo: UserIconInfo = new UserIconInfo(this.currentUserId);

  private iconUpdateCallback = () => {
    this.updateUserIconInfo();
    BootCompletedAnimationController.getInstance().isUserDataPrepared = true;
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear');
    this.updateUserIconInfo();
    UserIconViewModel.getInstance().registerUserIconUpdatedCallback(this.currentUserId, this.iconUpdateCallback);
  }

  private updateUserIconInfo(): void {
    this.userIconInfo = UserIconViewModel.getInstance().getCurrentUserIconInfo(this.currentUserId);
  }

  aboutToDisappear() {
    UserIconViewModel.getInstance().unregisterUserIconUpdatedCallback(this.currentUserId);
    log.showInfo('aboutToDisappear');
  }

  build() {
    if (this.userIconInfo.iconImage) {
      Image(this.userIconInfo.iconImage)
        .id(Constants.KEY_USER_ICON)
        .draggable(false)
        .width(this.accountsStyle?.userIconWidth)
        .height(this.accountsStyle?.userIconHeight)
        .borderRadius(this.accountsStyle?.userIconRadius)
    }
  }
}