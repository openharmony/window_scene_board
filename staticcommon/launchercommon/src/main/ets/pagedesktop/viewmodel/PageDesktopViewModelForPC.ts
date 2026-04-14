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

import { RightMenuViewModel } from './RightMenuViewModel';
import { CommonConstants } from '../../constants/CommonConstants';
import {
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import { BaseViewModel } from '../../base/BaseViewModel';

const TAG = 'PageDesktopViewModelForPC';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class PageDesktopViewModelForPC extends BaseViewModel {

  private static mInstance: PageDesktopViewModelForPC;

  private keyBoardStatus: number = CommonConstants.NO_KEYBOARD;

  private rightMenuViewModel: RightMenuViewModel = new RightMenuViewModel();

  static getInstance(): PageDesktopViewModelForPC {
    if (PageDesktopViewModelForPC.mInstance == null) {
      PageDesktopViewModelForPC.mInstance = new PageDesktopViewModelForPC();
    }
    return PageDesktopViewModelForPC.mInstance;
  }

  public setKeyBoardStatus(keyBoardStatus: number, msg: string): void {
    log.showInfo(TAG, `msg: ${msg}, keyBoardStatus: ${keyBoardStatus}`);
    this.keyBoardStatus = keyBoardStatus;
  }

  public getKeyBoardStatus(): number {
    return this.keyBoardStatus;
  }

  public setRightMenuViewModel(rightMenuViewModel: RightMenuViewModel): void {
    this.rightMenuViewModel = rightMenuViewModel;
  }

  public getRightMenuViewModel(): RightMenuViewModel {
    return this.rightMenuViewModel;
  }
}