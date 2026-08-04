/**
 * Copyright (c) 2025-2025 Huawei Device Co., Ltd.
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

import { BuilderNode } from '@kit.ArkUI';
import type Want from '@ohos.app.ability.Want';
import { Logger, LogDomain, CommonUtils } from '@ohos/basicutils';
import { GlobalContext, localEventManager } from '@ohos/frameworkwrapper';
import { DesktopUtils, FormLayoutCacheManager, GridLayoutItemInfo } from '../TsIndex';
import { EventConstants } from '../constants/EventConstants';

const TAG: string = 'CardNodeControllerManager';
const log: Logger = Logger.getLogHelper(LogDomain.FORM);

export interface FormComponentBasicEvent {
  onError: (e: IErrorInfo) => void;
  onAcquired: (form: FormCallbackInfo) => void;
  onRouter: () => void;
  onUninstall: (form: FormCallbackInfo) => void;
  onTouch?: (event: TouchEvent) => void;
  onLoad?: () => void;
}

export class FormComponentBasicData {
  cardId: string;
  cardName: string;
  bundleName: string;
  abilityName: string;
  moduleName: string;
  cardDimension: number;
  want: Want;
  borderRadius: number = 0;
  compId: string;
  hoverEffect: number | undefined;
  updateLocation: boolean = true;
  width: number;
  height: number;
  exemptAppLock?: boolean;

  constructor(cardId: string, cardName: string, bundleName: string, abilityName: string, moduleName: string,
    cardDimension: number, want: Want, borderRadius: number,
    width: number, height: number, compId?: string, hoverEffect?: number, exemptAppLock?: boolean,
    updateLocation = true) {
    this.cardId = cardId;
    this.cardName = cardName;
    this.bundleName = bundleName;
    this.abilityName = abilityName;
    this.moduleName = moduleName;
    this.cardDimension = cardDimension;
    this.want = want;
    this.borderRadius = borderRadius;
    this.width = width;
    this.height = height;
    this.compId = compId ?? '';
    this.hoverEffect = hoverEffect || HoverEffect.Auto;
    this.exemptAppLock = exemptAppLock;
    this.updateLocation = updateLocation;
  }
}

export class FormBasicParams {
  basicData: FormComponentBasicData;
  basicEvent: FormComponentBasicEvent;
  constructor(basicData: FormComponentBasicData, eventCb: FormComponentBasicEvent) {
    this.basicData = basicData;
    this.basicEvent = eventCb;
  }
}

export class FormOccupyParams {
  cardId: string;
  formParams?: FormBasicParams;
  constructor(cardId: string) {
    this.cardId = cardId;
  }
}

export class CardNodeOption {
  highestPriority: boolean = false;
  destroyImmediately: boolean = false;
  constructor(highestPriority = false, destroyImmediately = false) {
    this.highestPriority = highestPriority;
    this.destroyImmediately = destroyImmediately;
  }
}

export class CardNodeControllerManager {
  private static cardNodeCache: Map<string, BuilderNode<[FormBasicParams]> | null> =
    new Map<string, BuilderNode<[FormBasicParams]> | null>();
  private static cardControllerCache: Map<string, object> = new Map<string, object>();

  public static getNodeCacheSize(): number {
    return CardNodeControllerManager.cardNodeCache.size;
  }

  public static getFormKey(): string[] {
    let keys: IterableIterator<string> = CardNodeControllerManager.cardNodeCache.keys();
    const ret: string[] = [];
    for (let key of keys) {
      ret.push(key);
    }
    return ret;
  }

  public static getCardNode(cardId: string): BuilderNode<[FormBasicParams]> | null {
    return CardNodeControllerManager.cardNodeCache.get(cardId) ?? null;
  }

  public static deleteCardNode(cardId: string): void {
    CardNodeControllerManager.cardNodeCache.delete(cardId);
  }

  public static setCardNode(cardId: string, node: BuilderNode<[FormBasicParams]> | null): void {
    CardNodeControllerManager.cardNodeCache.set(cardId, node);
  }

  public static updateCardNode(cardId: string, newCardId: string): void {
    const node: BuilderNode<[FormBasicParams]> | null | undefined = CardNodeControllerManager.getCardNode(cardId);
    CardNodeControllerManager.deleteCardNode(cardId);
    CardNodeControllerManager.setCardNode(newCardId, node || null);
  }

  public static getCardController(cardId: string): object {
    return CardNodeControllerManager.cardControllerCache.get(cardId) as Object;
  }

  public static deleteCardController(cardId: string): void {
    CardNodeControllerManager.cardControllerCache.delete(cardId);
  }

  public static setCardController(cardId: string, controller: object): void {
    CardNodeControllerManager.cardControllerCache.set(cardId, controller);
  }

  public static updateCardController(cardId: string, newCardId: string): void {
    const controller = CardNodeControllerManager.getCardController(cardId);
    CardNodeControllerManager.deleteCardController(cardId);
    CardNodeControllerManager.setCardController(newCardId, controller);
  }

  public static destroyNodeByCardId(cardId: string): void {
    log.showInfo(TAG, `delete all FormComponent Node; cardId = ${cardId}`);
    CardNodeControllerManager.cardControllerCache.delete(cardId);
    CardNodeControllerManager.cardNodeCache.get(cardId)?.dispose();
    CardNodeControllerManager.cardNodeCache.delete(cardId);
  }

  public static destroyFormNodeByCardId(cardId: string): void {
    log.showInfo(TAG, `delete FC FormComponent Node; cardId = ${cardId}`);
    CardNodeControllerManager.cardControllerCache.delete(cardId);
    CardNodeControllerManager.cardNodeCache.get(cardId)?.dispose();
    CardNodeControllerManager.cardNodeCache.delete(cardId);
  }

  public static cardIdInCache(cardId: string): boolean {
    let desktopCacheList: string[] =
      FormLayoutCacheManager.getInstance().selectAllFormsList(false).map(i => i.cardId ?? '');
    log.showInfo(TAG, `cache cachesList = ${desktopCacheList}`);
    localEventManager.sendLocalEventSticky(EventConstants.INTELLIGENT_GET_FROM_ID_LIST_CALLBACK, {
      callback: (list?: string[]) => {
        log.showInfo(TAG, `IntelligentCardsView cachesList = ${list}`);
        if (list) {
          desktopCacheList = desktopCacheList.concat(list);
        }
      }
    });
    const dragItemInfo = AppStorage.get('dragItemInfo') as GridLayoutItemInfo;
    if (dragItemInfo) {
      log.showInfo(TAG, `dragging card id = ${dragItemInfo.cardId}`);
      desktopCacheList.push(dragItemInfo.cardId);
    }
    log.showInfo(TAG, `to check cardId = ${cardId} is in cache`);
    for (let i = 0; i < desktopCacheList.length; i++) {
      if (desktopCacheList[i] === cardId) {
        return true;
      }
    }
    return false;
  }
}

export interface IErrorInfo {
  errcode: number;
  msg: string
}
