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

import { image } from '@kit.ImageKit';
import { componentSnapshot } from '@kit.ArkUI';
import { LogDomain, LogHelper, PixelMapUtil } from '@ohos/basicutils';
import { EventConstants, FormModel, ReceiveEventInfo } from '@ohos/launchercommon';
import { FormZoomUtil } from './FormZoomUtil';
import { localEventManager } from '@ohos/frameworkwrapper';
import { FormZoomViewManager } from '@ohos/launchercommon/src/main/ets/manager/FormZoomViewManager';

const TAG: string = 'FormZoomManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class FormZoomManager {
  private static mInstance: FormZoomManager;
  private mFormZoomSnapshot?: image.PixelMap;
  private mFormZoomLocked: boolean = false;
  private mCardSnapshot: Map<string, image.PixelMap> = new Map();
  private mOldCardId: string = '';
  private mTempCardIdSet: Set<string> = new Set();
  private mIsReady: boolean = true;
  private dragStateChangeCallback?: (state: boolean) => void = undefined;

  private constructor() {
    this.registerTouchEvent();
  }

  private readonly formZoomEventListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: string) => {
      if (event === EventConstants.EVENT_EDIT_MODE_TOUCH_DOWN_ITEM ||
        event === EventConstants.EVENT_REQUEST_OUTER_CARD_DELETE) {
        if (!this.mFormZoomLocked) {
          this.reset();
          this.setIsReady(false);
        }
      }
    }
  };

  public static getInstance(): FormZoomManager {
    if (!FormZoomManager.mInstance) {
      FormZoomManager.mInstance = new FormZoomManager();
    }
    return FormZoomManager.mInstance;
  }

  public getFormZoomSnapshot(): image.PixelMap | undefined {
    return this.mFormZoomSnapshot;
  }

  public setFormZoomSnapshot(formComponentId: string, cardSize: Size | undefined): void {
    log.showWarn(`update form zoom snapshot: ${formComponentId}`);
    let oldSnapshot: image.PixelMap | undefined = this.mFormZoomSnapshot;
    componentSnapshot.get(formComponentId).then((value: image.PixelMap) => {
      PixelMapUtil.addName(value, `FormZoom_card_snapshot_${formComponentId}`);
      let validRegion: image.Region | undefined = FormZoomUtil.getValidRegion(value, cardSize);
      // 裁剪真实卡片区域
      if (validRegion) {
        value.cropSync(validRegion);
      }
      this.mFormZoomSnapshot = value;
      AppStorage.setOrCreate('showFormZoomSnapshot', true);
    }).catch((err: Error) => {
      log.showError(`componentSnapshot failed: ${err?.message}`);
    }).finally(() => {
      if (oldSnapshot) {
        oldSnapshot.release();
      }
    })
  }

  public deleteFormZoomSnapshot(): void {
    if (this.mFormZoomSnapshot) {
      this.mFormZoomSnapshot.release();
    }
  }

  public setFormZoomLocked(value: boolean): void {
    log.showInfo(`set form zoom lock status: ${value}`);
    this.mFormZoomLocked = value;
  }

  public isFormZoomLocked(): boolean {
    return this.mFormZoomLocked;
  }

  public addTempCardId(cardId: string): void {
    log.showWarn(`add temp card id: ${cardId}`);
    this.mTempCardIdSet.add(cardId);
  }

  public clearTempCard(): void {
    this.mTempCardIdSet.forEach((cardId: string) => {
      log.showWarn(`delete temp card id: ${cardId}`);
      FormModel.getInstance().deleteFormById(cardId, false, false, 0);
    })
    this.mTempCardIdSet.clear();
  }

  public setCardSnapshot(id: string): void {
    setTimeout(() => {
      componentSnapshot.get(id).then((value: image.PixelMap) => {
        PixelMapUtil.addName(value, `FormZoom_temp_card_snapshot_${id}`);
        this.mCardSnapshot.set(id, value);
      }).catch((err: Error) => {
        log.showError(`componentSnapshot failed: ${JSON.stringify(err)}`);
      });
    }, 1000);
  }

  public getCardSnapshot(key: string): image.PixelMap | undefined {
    return this.mCardSnapshot.get(key);
  }

  public releaseSnapshot(): void {
    this.mCardSnapshot.forEach((value: image.PixelMap) => {
      if (value) {
        value.release();
      }
    })
    this.mCardSnapshot.clear();
  }

  public setOldCardId(cardId: string): void {
    log.showWarn(`set old card id: ${cardId}`);
    this.mOldCardId = cardId;
  }

  public deleteOldCard(): void {
    if (this.mOldCardId) {
      log.showWarn(`delteOldCard: ${this.mOldCardId}`);
      FormModel.getInstance().deleteFormById(this.mOldCardId, false, false, 0);
      this.mOldCardId = '';
    }
  }

  public setIsReady(value: boolean): void {
    this.mIsReady = value;
  }

  public isReady(): boolean {
    return this.mIsReady;
  }

  public registerTouchEvent(): void {
    localEventManager.unregisterEventListener(this.formZoomEventListener);
    localEventManager.registerEventListener(this.formZoomEventListener, [
      EventConstants.EVENT_EDIT_MODE_TOUCH_DOWN_ITEM,
      EventConstants.EVENT_REQUEST_OUTER_CARD_DELETE,
    ]);
  }

  public registerFormZoomDragStateChange(callback: (state: boolean) => void): void {
    this.dragStateChangeCallback = callback;
  }

  public unRegisterFormZoomDragStateChange(): void {
    this.dragStateChangeCallback = undefined;
  }

  public notifyFormZoomDragStateChange(state: boolean): void {
    if (this.dragStateChangeCallback) {
      this.dragStateChangeCallback(state);
    }
  }

  public reset(): void {
    this.deleteFormZoomSnapshot();
    AppStorage.setOrCreate('formZoomId', '-1');
    AppStorage.setOrCreate('showFormZoomSnapshot', false);
    FormZoomViewManager.getInstance().closeFormZoomView();
  }
}