/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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

import type image from '@ohos.multimedia.image';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import type { DragItemPosition } from '@ohos/componentdrag';
import type { CardItemInfo } from '@ohos/launchercommon';
import { FormStackUtil } from './FormStackUtil';
import { FormStackConstants } from './FormStackConstants';

const TAG = 'FormStackManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

const CLEAR_DRAG_CACHE_IMG_DELAY_MS = 3000;

interface ImgData {
  pixmap: image.PixelMap;
}

export class FormStackManager {
  private static mInstance: FormStackManager;
  private mFormStackId: string = '';
  private mTopFormId: string = '';
  private breakFormStackExpandAnimation: Function | undefined = undefined;
  private mDragItemPosition?: DragItemPosition;
  private mFormStackMap: Map<string, CardItemInfo[]> = new Map<string, CardItemInfo[]>();
  private mFormStackIdsInAnimate: Set<string> = new Set<string>();
  // 遮罩卡片组件ID
  private mImageCacheKey: string = '';
  private mStackName: string = '';
  // 堆叠所在宫格位置[page, row, column]
  private mFormStackPos: number[] = [];

  static getInstance(): FormStackManager {
    if (FormStackManager.mInstance == null) {
      FormStackManager.mInstance = new FormStackManager();
    }
    return FormStackManager.mInstance;
  }

  public setFormStackId(id: string): void {
    if (CheckEmptyUtils.checkStrIsEmpty(id)) {
      log.showError('form stack id is empty!');
      return;
    }

    log.showInfo(`set form stack id: ${id}.`);
    this.mFormStackId = id;
  }

  public getFormStackId(): string {
    return this.mFormStackId;
  }

  public setStackName(stackName: string): void {
    log.showInfo(`set stack name is: ${stackName}.`);
    this.mStackName = stackName;
  }

  public getStackName(): string {
    log.showInfo(`get stack name is: ${this.mStackName}.`);
    return this.mStackName;
  }

  public clearFormStackId(): void {
    this.mFormStackId = '';
  }

  public setClickTopFormId(formId: string): void {
    log.showInfo(`set click top form id: ${formId}.`);
    this.mTopFormId = formId;
  }

  public getTopFormId(): string {
    return this.mTopFormId;
  }

  public clearTopFormId(): void {
    this.mTopFormId = '';
  }

  public setBreakFormStackExpandAnimation(callback?: Function): void {
    log.showInfo(`set form stack expand animating flag.`);
    this.breakFormStackExpandAnimation = callback;
  }

  public getBreakFormStackExpandAnimation(): Function | undefined {
    return this.breakFormStackExpandAnimation;
  }

  public saveDragOriginPosition(cardInfo: CardItemInfo): void {
    const position: DragItemPosition = {
      page: cardInfo.page ?? -1,
      column: cardInfo.column ?? -1,
      row: cardInfo.row ?? -1,
      x: 0,
      y: 0,
    };
    this.mDragItemPosition = position;
  }

  public resetDragOriginPosition(): void {
    this.mDragItemPosition = undefined;
  }

  public getDragOriginPosition(): DragItemPosition | undefined {
    return this.mDragItemPosition;
  }

  public deleteFormStackCards(formStackId: string): void {
    this.mFormStackMap.delete(formStackId);
  }

  public getFormStackSubCards(formStackId: string): CardItemInfo[] {
    let cardInfoList: CardItemInfo[] | undefined = this.mFormStackMap.get(formStackId);
    if (!cardInfoList) {
      cardInfoList = [];
    }
    this.mFormStackMap.set(formStackId, cardInfoList);
    return cardInfoList;
  }

  public isFormStackInAnimate(formStackId: string): boolean {
    return this.mFormStackIdsInAnimate.has(formStackId);
  }

  public cacheFormStackIdInAnimate(formStackId: string): void {
    this.mFormStackIdsInAnimate.add(formStackId);
  }

  public deleteFormStackIdInAnimate(formStackId: string): void {
    this.mFormStackIdsInAnimate.delete(formStackId);
  }

  public setFormStackPosition(position: number[]): void {
    if (CheckEmptyUtils.isEmptyArr(position) || position.length < FormStackConstants.FORMSTACK_POS_ARRAY_LEN) {
      log.showError('formstack position info invalid!');
      return;
    }

    this.mFormStackPos.slice(0, this.mFormStackPos.length);
    this.mFormStackPos = position;
    log.showWarn(`formstack position, page: ${position[0]}, row: ${position[1]}, column: ${position[2]}`);
  }

  public getFormStackPosition(): number[] {
    return this.mFormStackPos;
  }
}