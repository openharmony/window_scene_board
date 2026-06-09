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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { EditModePageTypeEnum, EditModePageUtil } from '../data/PageEditData';

const PAGE_HIDE_DURATION: number = 400;
const TAG = 'PageEditAnimationManager'
const log = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class PageEditAnimationManager {
  private hookList: PageEditAnimateHook[] = [];

  private doAnimateTo(param: AnimateParam, callback: () => void): Promise<void> {
    return new Promise((resolve) => {
      param.onFinish = () => resolve();
      animateTo(param, () => {
        callback();
      })
    })
  }

  public async recoverPageAnimationProperty() {
    this.hookList.forEach(item => {
      item.apply(0, true);
    });
  }

  public registerHook(hook: PageEditAnimateHook): boolean {
    if (this.hookList.find(item => item === hook)) {
      return false;
    }
    this.hookList.push(hook);
    return true;
  }

  public unRegisterHook(hook: PageEditAnimateHook): boolean {
    let index = this.hookList.findIndex(item => item === hook);
    if (index === -1) {
      log.showInfo('hook not found');
      return false;
    }
    this.hookList.splice(index, 1);
    return true;
  }
}


export class PageEditAnimateHook {
  private mPageType: EditModePageTypeEnum = EditModePageTypeEnum.NORMAL;
  private mPageIndex: number = 0;
  private applyPagePropertyCallback: ((offset?: number, visible?: boolean) => void) | undefined = undefined;
  private onUpdateIndex: (() => number) | undefined = undefined;

  public load(
    pageType: EditModePageTypeEnum,
    onUpdateIndex: () => number,
    onApplyPageProperty: (offset?: number, visible?: boolean) => void
  ) {
    this.mPageType = pageType;
    this.onUpdateIndex = onUpdateIndex;
    this.mPageIndex = onUpdateIndex();
    this.applyPagePropertyCallback = onApplyPageProperty;
    pageEditAnimationManager.registerHook(this);
  }

  public unload() {
    this.applyPagePropertyCallback = undefined;
    pageEditAnimationManager.unRegisterHook(this);
  }

  public apply(offset?: number, visible?: boolean): void {
    this.applyPagePropertyCallback?.(offset, visible);
  }

  public updateIndex() {
    if (this.onUpdateIndex) {
      this.mPageIndex = this.onUpdateIndex();
    }
  }

  public get pageIndex() {
    return this.mPageIndex;
  }

  public get pageType() {
    return this.mPageType;
  }
}


export const pageEditAnimationManager =
  SingletonHelper.getInstance(PageEditAnimationManager, 'EditModePageAnimationManager');
