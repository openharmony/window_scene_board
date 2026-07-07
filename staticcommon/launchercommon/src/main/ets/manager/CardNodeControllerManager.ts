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

export interface AiFormStackItemBuildInterface {
  // 创建View
  buildView: () => WrappedBuilder<AiFormBasicParams[]>;
}

export interface  FormComponentBasicEvent {
  // 组件内部异常回调
  onError: (e: IErrorInfo) => void;
  // 唯一性标识更新，会触发UI组件上下树
  onAcquired: (form: FormCallbackInfo) => void;
  // 卡片点击启动
  onRouter: () => void;
  // 卡片uninstall回调
  onUninstall: (form: FormCallbackInfo) => void;
  // 卡片点击事件
  onTouch?: (event: TouchEvent) => void;
  // onLoad事件
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
  compId: string; // 节点ID
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
    // 卡片6要素/相关事件
    this.basicData = basicData;
    this.basicEvent = eventCb;
  }
}

export class AiFormComponentBasicData {
  cardId: string;
  width: number;
  height: number;
  formItem: GridLayoutItemInfo;
  borderRadius: number;
  containerId: string;
  isOuterDesktop: boolean;
  isLongPressZoomIn: boolean;
  isCreateFormAnimation: boolean;
  isFormStackChildItem: boolean;
  constructor(cardId: string, formItemWidth: number, formItemHeight: number, formItem: GridLayoutItemInfo,
    borderRadius: number, containerId: string, isOuterDesktop: boolean, isLongPressZoomIn = false,
    isCreateFormAnimation = false, isFormStackChildItem = false) {
    // 语音助手建议参数
    this.cardId = cardId;
    this.width = formItemWidth;
    this.height = formItemHeight;
    this.formItem = formItem;
    this.isCreateFormAnimation = isCreateFormAnimation;
    this.borderRadius = borderRadius;
    this.containerId = containerId;
    this.isLongPressZoomIn = isLongPressZoomIn;
    this.isOuterDesktop = isOuterDesktop;
    this.isFormStackChildItem = isFormStackChildItem;
  }
}

export class AiFormComponentBasicEvent {
  deleteForm?: (playAnimation: boolean, formItem?: GridLayoutItemInfo, isOuter?: boolean) => void;
  updateFormId?: Function;
  updateAppName?: (name: string) => void;
  onItemHover?: (event: HoverEvent) => void;
  onItemSelected?: (index: number) => void;
  isUseEffect?: (useEffect: boolean) => void;
  isDuringAppExitAnim?: (isAppExiting: boolean) => void;
}

// 语音助手建议
export class AiFormBasicParams {
  basicData: AiFormComponentBasicData;
  basicEvent?: AiFormComponentBasicEvent;
  constructor(basicData: AiFormComponentBasicData, basicEvent?: AiFormComponentBasicEvent) {
    this.basicData = basicData;
    this.basicEvent = basicEvent;
  }
}

// 占位参数
export class FormOccupyParams {
  cardId: string;
  isAiCard: boolean;
  formParams?: FormBasicParams | AiFormBasicParams; // 记录抢占节点的数据信息
  constructor(cardId: string, isAiCard = false) {
    this.cardId = cardId;
    this.isAiCard = isAiCard;
  }
}

// 节点配置项
export class CardNodeOption {
  highestPriority: boolean = false;
  destroyImmediately: boolean = false;
  constructor(highestPriority = false, destroyImmediately = false) {
    this.highestPriority = highestPriority;
    this.destroyImmediately = destroyImmediately;
  }
}

const checkLeakDelay: number = 30000; // 延时30s去检测引用节点泄漏

export class CardNodeControllerManager {
  private static cardNodeCache: Map<string, BuilderNode<[FormBasicParams]> | null> =
    new Map<string, BuilderNode<[FormBasicParams]> | null>();
  private static aiCardNodeCache: Map<string, BuilderNode<[object]> | null> =
    new Map<string, BuilderNode<[object]> | null>(); // 语音助手建议节点缓存
  private static cardControllerCache: Map<string, object> = new Map<string, object>();
  private static aiCardControllerCache: Map<string, object> = new Map<string, object>(); // 语音助手建议controller缓存
  private static aiSuggestionBuilder: AiFormStackItemBuildInterface | null = null;

  public static getNodeCacheSize(): number {
    return CardNodeControllerManager.cardNodeCache.size + CardNodeControllerManager.aiCardNodeCache.size;
  }

  public static getFormKey(): string[] {
    let keys: IterableIterator<string> = CardNodeControllerManager.cardNodeCache.keys();
    const ret: string[] = [];
    for (let key of keys) {
      ret.push(key);
    }
    return ret;
  }

  public static getAiFormKey(): string[] {
    const keys = CardNodeControllerManager.aiCardNodeCache.keys();
    const ret: string[] = [];
    for (let key of keys) {
      ret.push(key);
    }
    return ret;
  }

  public static getCardNode(cardId: string): BuilderNode<[FormBasicParams]> | null {
    return CardNodeControllerManager.cardNodeCache.get(cardId) ?? null;
  }

  public static getAiCardNode(cardId: string): BuilderNode<[object]> | null {
    return CardNodeControllerManager.aiCardNodeCache.get(cardId) ?? null;
  }

  public static deleteCardNode(cardId: string): void {
    CardNodeControllerManager.cardNodeCache.delete(cardId);
  }

  public static deleteAiCardNode(cardId: string): void {
    CardNodeControllerManager.aiCardNodeCache.delete(cardId);
  }

  public static setCardNode(cardId: string, node: BuilderNode<[FormBasicParams]> | null): void {
    CardNodeControllerManager.cardNodeCache.set(cardId, node);
  }

  public static setAiCardNode(cardId: string, node: BuilderNode<[FormBasicParams]> | null): void {
    CardNodeControllerManager.aiCardNodeCache.set(cardId, node);
    GlobalContext.getContext()?.eventHub?.emit(`${EventConstants.EVENT_AI_CARDNODE_UPDATE}_${cardId}`, cardId);
  }

  public static updateCardNode(cardId: string, newCardId: string): void {
    const node: BuilderNode<[FormBasicParams]> | null | undefined = CardNodeControllerManager.getCardNode(cardId);
    CardNodeControllerManager.deleteCardNode(cardId);
    CardNodeControllerManager.setCardNode(newCardId, node || null);
  }

  public static updateAiCardNode(cardId: string, newCardId: string): void {
    const node: BuilderNode<[FormBasicParams]> | null | undefined = CardNodeControllerManager.getAiCardNode(cardId);
    CardNodeControllerManager.deleteAiCardNode(cardId);
    CardNodeControllerManager.setAiCardNode(newCardId, node || null);
  }

  public static getCardController(cardId: string): object {
    return CardNodeControllerManager.cardControllerCache.get(cardId) as Object;
  }

  public static getAiCardController(cardId: string): object {
    return CardNodeControllerManager.aiCardControllerCache.get(cardId) as Object;
  }

  public static deleteCardController(cardId: string): void {
    CardNodeControllerManager.cardControllerCache.delete(cardId);
  }

  public static deleteAiCardController(cardId: string): void {
    CardNodeControllerManager.aiCardControllerCache.delete(cardId);
  }

  public static setCardController(cardId: string, controller: object): void {
    CardNodeControllerManager.cardControllerCache.set(cardId, controller);
  }

  public static setAiCardController(cardId: string, controller: object): void {
    CardNodeControllerManager.aiCardControllerCache.set(cardId, controller);
  }

  public static updateCardController(cardId: string, newCardId: string): void {
    const controller = CardNodeControllerManager.getCardController(cardId);
    CardNodeControllerManager.deleteCardController(cardId);
    CardNodeControllerManager.setCardController(newCardId, controller);
  }

  public static updateAiCardController(cardId: string, newCardId: string): void {
    const controller = CardNodeControllerManager.getAiCardController(cardId);
    CardNodeControllerManager.deleteAiCardController(cardId);
    CardNodeControllerManager.setAiCardController(newCardId, controller);
  }

  // 语音助手卡片Builder
  public static setAiSuggestionBuildItem(aiSuggestionBuilder: AiFormStackItemBuildInterface): void {
    CardNodeControllerManager.aiSuggestionBuilder = aiSuggestionBuilder;
  }

  public static getAiSuggestionBuildItem() : AiFormStackItemBuildInterface | null {
    return CardNodeControllerManager.aiSuggestionBuilder;
  }

  // 销毁节点
  public static destroyNodeByCardId(cardId: string): void {
    log.showInfo(TAG,`delete all FormComponent Node; cardId = ${cardId}`);
    CardNodeControllerManager.cardControllerCache.delete(cardId);
    CardNodeControllerManager.aiCardControllerCache.delete(cardId);
    CardNodeControllerManager.cardNodeCache.get(cardId)?.dispose();
    CardNodeControllerManager.aiCardNodeCache.get(cardId)?.dispose();
    CardNodeControllerManager.cardNodeCache.delete(cardId);
    CardNodeControllerManager.aiCardNodeCache.delete(cardId);
  }

  // 销毁普通卡片节点
  public static destroyFormNodeByCardId(cardId: string): void {
    log.showInfo(TAG,`delete FC FormComponent Node; cardId = ${cardId}`);
    CardNodeControllerManager.cardControllerCache.delete(cardId);
    CardNodeControllerManager.cardNodeCache.get(cardId)?.dispose();
    CardNodeControllerManager.cardNodeCache.delete(cardId);
  }

  // 检测卡片ID是否在缓存中
  public static cardIdInCache(cardId: string): boolean {
    // 桌面缓存
    let desktopCacheList: string[] =
      FormLayoutCacheManager.getInstance().selectAllFormsList(false).map(i => i.cardId ?? '');
    log.showInfo(TAG, `cache cachesList = ${desktopCacheList}`);
    // 负一屏缓存
    localEventManager.sendLocalEventSticky(EventConstants.INTELLIGENT_GET_FROM_ID_LIST_CALLBACK, {
      callback: (list?: string[]) => {
        // 负一屏卡片
        log.showInfo(TAG, `IntelligentCardsView cachesList = ${list}`);
        if (list) {
          desktopCacheList = desktopCacheList.concat(list);
        }
      }
    });
    const dragItemInfo = AppStorage.get('dragItemInfo') as GridLayoutItemInfo;
    // 正在拖拽的
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
