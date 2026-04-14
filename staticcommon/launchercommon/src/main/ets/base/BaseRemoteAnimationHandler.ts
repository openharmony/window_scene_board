/**
 * Copyright (c) 2022-2022 Huawei Device Co., Ltd.
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

import { LogDomain, LogHelper, SingleBase, SingleContext, StartType } from '@ohos/basicutils';

const TAG = 'BaseRemoteAnimationHandler';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * remote animation base class
 */
export abstract class BaseRemoteAnimationHandler extends SingleBase {
  public static singleName: string = 'BaseRemoteAnimationHandler';
  public mAppIconSize: number = 0;
  public mAppIconHeight: number = 0;
  public mAppIconPositionX: number = 0;
  public mAppIconPositionY: number = 0;
  public mStartAppType: StartType = StartType.APP;
  public mCardId: string = '';
  public mExtraId: string = '';
  public mShortcutId: string = '';

  constructor(ctx?: SingleContext) {
    super(ctx);
  }

  /**
   * set app icon size
   *
   * @param appIconSize appIconSize
  */
  public setAppIconSize(appIconSize: number, appIconHeight?: number): void {
    if (appIconHeight !== undefined) {
      this.mAppIconHeight = appIconHeight;
    }
    this.mAppIconSize = appIconSize;
    log.showDebug(`setAppIconSize appIconSize is ${appIconSize} , appIconHeight is ${appIconHeight}`);
  }

  /**
   * calculate app icon position.
   */
  protected abstract calculateAppIconPosition(): void;

  /**
   * set app icon info.
   */
  public setAppIconInfo(): void {
    this.calculateAppIconPosition();
    log.showInfo(`setAppIconInfo appIconSize ${this.mAppIconSize} appIconPositionX ${this.mAppIconPositionX} appIconPositionY ${this.mAppIconPositionY}`);
  }

  public setStartAppType(startAppType: StartType, cardId?: string, extraId?: string, shortcutId?: string): void {
    this.mStartAppType = startAppType;
    this.mCardId = cardId ?? '';
    this.mExtraId = extraId ?? '';
    this.mShortcutId = shortcutId ?? '';
  }
}