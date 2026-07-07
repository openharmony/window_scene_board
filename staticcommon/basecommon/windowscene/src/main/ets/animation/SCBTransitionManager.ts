/*
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

import {
  SCBTransitionController,
  SCBExpandController,
  SCBFoldController,
  AppData,
  SCBTripleController,
  SCBTripleControllerArray
} from './SCBTransitionController';
import { SCBTransitionControllerArray, SCBFoldControllerArray, SCBExpandControllerArray } from './SCBTransitionController';
import type { SCBAppExitToFolderController } from './SCBTransitionController';
import { SCBAppExitToFolderControllerArray } from './SCBTransitionController';
import { CommonUtils } from '@ohos/basicutils';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { CheckEmptyUtils } from '@ohos/basicutils';
import { SCBConstants } from '@ohos/commonconstants';
import { SCBSceneContainerSession, SCBSceneContainerSessionArray} from '../scene/session/SCBSceneContainerSession';
import { DeviceHelper, IntelligentCache } from '@ohos/frameworkwrapper';
import { SCBWindowSceneConfig, ScreenState } from '@ohos/frameworkwrapper';
import { SCBSceneInfo, SCBSceneSessionManager } from '../TsIndex';
import { StartType } from '@ohos/basicutils';

const TAG = 'SCBTM';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export enum SCBDesktopEventId {
  SWIPE_UP_FROM_HOME,
  SWIPE_UP_BACK_HOME_FROM_HOME
};

export class SCBTransitionManager {
  transitionControllerList: SCBTransitionControllerArray = new SCBTransitionControllerArray();
  globalTransitionControllerList: SCBTransitionControllerArray = new SCBTransitionControllerArray();
  appExitToFolderControllerList: SCBAppExitToFolderControllerArray = new SCBAppExitToFolderControllerArray();
  private callbackMap: Map<number, Array<Function>> = new Map();
  private unlockTransitionControllerList: Array<SCBUnlockTransitionController> = new Array<SCBUnlockTransitionController>();
  private unlockTransitionEnterHomeList: Array<SCBUnlockTransitionController> = new Array<SCBUnlockTransitionController>();
  private screenChangeTransitionControllerList: Array<SCBScreenStateChangeTransitionController> =
    new Array<SCBScreenStateChangeTransitionController>();
  private foldAnimationControllerList: SCBFoldControllerArray = new SCBFoldControllerArray();
  private expandAnimationControllerList: SCBExpandControllerArray = new SCBExpandControllerArray();
  private tripleAnimationControllerList: SCBTripleControllerArray = new SCBTripleControllerArray();
  private currentTransitionController: SCBTransitionController = null;
  private animationMap: Map<string, number> = new Map(); // key: iconId, value: animationCount
  // 不区分应用，启动/退出动效计数，主要解决不同的应用启动退出互相打断场景节点组标记失效问题
  private startExitAnimationCount: number = 0;
  private unlockSpaceAniListerner: SCBUnlockSpaceAniListener = null;
  private cancelCloseAppAnimateFun?: Function;
  private sceneContainerSession?: SCBSceneContainerSession;
  // 是否在退出翻页中
  public isExitSwipeIng: boolean = false;
  private isExclusiveSwiperElementsCancelAnimate: boolean = false;
  private lastSwipeOffset: number = 0;
  private lastSwipeOffsetChanged: number = 0;

  /**
   * 设置退出最近的翻页位移
   * @param value 翻页位移量
   */
  public setLastSwipeOffset(value: number): void {
    this.lastSwipeOffset = value;
  }

  /**
   * 设置最近翻页偏移的改变量
   * @param value 偏移的改变量
   */
  public setLastSwipeOffsetChanged(value: number): void {
    this.lastSwipeOffsetChanged = value;
  }

  /**
   * 返回退出最近的翻页位移
   * @returns 最近的翻页位移
   */
  public getLastSwipeOffset(): number {
    return this.lastSwipeOffset;
  }

  /**
   * 返回最近翻页偏移的改变量
   * @returns 翻页偏移的改变量
   */
  public getLastSwipeOffsetChanged(): number {
    return this.lastSwipeOffsetChanged;
  }

  /**
   * 拓展overlay卡片动效控制
   */
  private overlayCardTranController: SCBTransitionController;

  static getInstance(): SCBTransitionManager {
    if (globalThis.SCBTransitionManagerInstance == null) {
      globalThis.SCBTransitionManagerInstance = new SCBTransitionManager();
    }
    return globalThis.SCBTransitionManagerInstance;
  }

  /**
   * 获取当前的启动/退出动效个数
   * 主要用于启动/退出的动效场景节点组标记
   */
  public getStartExitAnimationCount(): number {
    log.showInfo(`getStartExitAnimationCount animationCount:${this.startExitAnimationCount}`);
    return this.startExitAnimationCount;
  }

  /**
   * 启动/退出动效计数+1
   */
  public addStartExitAnimationCount(reason?: string): void {
    this.startExitAnimationCount++;
    AppStorage.setOrCreate<boolean>('isDuringStartExitAnimation', true);
    log.showInfo(`addStartExitAnimationCount reason:${reason} animationCount:${this.startExitAnimationCount}`);
  }

  /**
   * 启动/退出动效计数-1
   */
  public reduceStartExitAnimationCount(reason?: string): void {
    this.startExitAnimationCount--;
    if (this.startExitAnimationCount < 0) {
      this.startExitAnimationCount = 0;
    }
    if (this.startExitAnimationCount === 0) {
      AppStorage.setOrCreate<boolean>('isDuringStartExitAnimation', false);
    }
    log.showInfo(`reduceStartExitAnimationCount reason:${reason} animationCount:${this.startExitAnimationCount}`);
  }

  /**
   * 设置启动退出动效计数
   * @param value 设置启动退出计数的值
   * @param reason 设置启动退出计数的原因
   */
  public setStartExitAnimationCount(value: number, reason?: string): void {
    this.startExitAnimationCount = value;
    if (this.startExitAnimationCount === 0) {
      AppStorage.setOrCreate<boolean>('isDuringStartExitAnimation', false);
    } else {
      AppStorage.setOrCreate<boolean>('isDuringStartExitAnimation', true);
    }
    log.showInfo(`setStartExitAnimationCount is: ${this.startExitAnimationCount}, reason is: ${reason}`);
  }

  /**
   * 设置overlay卡片动效控制器
   * 主要用于通知卡片、胶囊卡片等临时卡片动效场景
   *
   * @param controller 动效控制器
   */
  setOverlayCardTransitionController(controller: SCBTransitionController): void {
    this.overlayCardTranController = controller;
    log.showInfo('setOverlayCardTransitionController: ' + controller?.overlayCardInfo?.startBundleName);
  }

  resetSpecOverlayTransitionController(controller?: SCBTransitionController): void {
    if (controller && this.overlayCardTranController === controller) {
      this.overlayCardTranController = undefined;
      log.showInfo('ClearSpecOverlayTransitionController succeed');
    } else {
      log.showWarn('ClearSpecOverlayTransitionController skip');
    }
  }

  registerTransitionController(controller: SCBTransitionController): void {
    if (controller === undefined || controller === null) {
      log.showError('registerTransitionController, controller null');
      return;
    }
    log.showInfo('registerTransitionController, icon id:' + controller.appData?.appIconId);
    let item = this.transitionControllerList.find(item => item === controller);
    if (item) {
      log.showInfo('transition controller has been registered. AppId: ' + controller.appData.appIconId);
    } else {
      this.transitionControllerList.splice(0, 0, controller);
    }
    log.showInfo('transitionControllerList length:' + this.transitionControllerList.length);
  }

  unRegisterTransitionController(controller: SCBTransitionController): void {
    if (controller === undefined || controller === null) {
      log.showError('unRegisterTransitionController, controller null');
      return;
    }
    let index = this.transitionControllerList.indexOf(controller);
    if (index === -1) {
      log.showWarn('unRegisterTransitionController failed, controller was not register');
    } else {
      // 从窗口container中删除controller，保证解注册后无关联持有逻辑，避免内存溢出
      this.removeSceneContainerController(controller);
      this.transitionControllerList.splice(index, 1);
    }
    log.showInfo('transitionControllerList length:' + this.transitionControllerList.length);
  }

  /**
   * 从窗口container中删除controller
   * @param controller 待删除controller
   */
  private removeSceneContainerController(controller: SCBTransitionController) : void {
    const appData : AppData = controller.appData;
    if (appData === undefined || appData === null) {
      log.showError('removeSceneContainerController, appData null');
      return;
    }
    let sessionArray : SCBSceneContainerSessionArray = SCBSceneSessionManager.getInstance().getContainerSessionList();
    if (sessionArray === null || sessionArray === undefined || sessionArray.isEmpty()) {
      return;
    }
    let removedCount : number = 0;
    sessionArray.forEach((session : SCBSceneContainerSession) => {
      if (session.transitionController === controller) {
        session.transitionController = null;
        removedCount ++;
      }
    })
    log.showWarn(`removeSceneContainerController finish removed count ${removedCount}`);
  }

  registerGlobalTransitionController(controller: SCBTransitionController): void {
    let item: SCBTransitionController = this.globalTransitionControllerList.find(item =>
    item === controller || item.appData.appIconId === controller.appData.appIconId
    );
    if (!item) {
      this.globalTransitionControllerList.push(controller);
    }
    log.showInfo('globalTransitionControllerList length:' + this.globalTransitionControllerList.length);
  }

  unRegisterGlobalTransitionController(controller: SCBTransitionController): void {
    let index: number = this.globalTransitionControllerList.findIndex(item =>
    item === controller || item.appData.appIconId === controller.appData.appIconId
    );
    if (index !== -1) {
      this.globalTransitionControllerList.splice(index);
    }
    log.showInfo('globalTransitionControllerList length:' + this.globalTransitionControllerList.length);
  }

  findTransitionController(bundleName: string, callback: Function): SCBTransitionController {
    // use overlayCardTranController first
    const uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    if (!CommonUtils.isInvalid(this.overlayCardTranController) &&
      CommonUtils.equals(bundleName, this.overlayCardTranController?.overlayCardInfo?.startBundleName) &&
      ((uiType === SCBConstants.UITYPE_PAD && !SCBSceneSessionManager.getInstance().isPcMode()) ||
        uiType === SCBConstants.UITYPE_PHONE)) {
      log.showInfo('findTransitionController overlay controller: ' +
        this.overlayCardTranController?.overlayCardInfo?.startBundleName);
      return this.overlayCardTranController;
    } else {
      log.showInfo('findTransitionController. bundleName: %{public}s, overlayBundleName: %{public}s', bundleName,
      this.overlayCardTranController?.overlayCardInfo?.startBundleName);
    }
    if (callback) {
      let findData: AppData = callback();
      let controller = this.findTransitionControllerInList(findData);
      if (controller) {
        return controller;
      } else {
        controller = this.findTransitionControllerInList(findData, false);
        if (controller) {
          return controller;
        }
        return this.findOtherTransitionController(findData, findData.startAppType);
      }
    }
    return null;
  }

  // 桌面应用于文件夹应用存在互换场景需进一步查找
  private findOtherTransitionController(findData: AppData, startType?: StartType): SCBTransitionController {
    if (startType === StartType.APP) {
      findData.startAppType = StartType.FOLDER;
      let controller = this.findTransitionControllerInList(findData);
      if (!controller) {
        controller = this.findTransitionControllerInList(findData, false);
      }
      return controller;
    }
    if (startType === StartType.FOLDER) {
      findData.startAppType = StartType.APP;
      return this.findTransitionControllerInList(findData);
    }
    // 落位查找兜底方案，按启动类型找不落位信息时，再优先依次从桌面跟文件夹中查找
    if (startType === StartType.CARD) {
      findData.startAppType = StartType.APP;
      let controller = this.findTransitionControllerInList(findData);
      if (!controller) {
        findData.startAppType = StartType.FOLDER;
        controller = this.findTransitionControllerInList(findData);
      }
      return controller;
    }
    return null;
  }

  private isOpeningFolder(): boolean {
    const openFolderId = AppStorage.get<string>('openFolderId');
    return openFolderId && openFolderId !== SCBConstants.INVALID_FOLDER_ID;
  }

  /**
   * 文件夹展开态图标isOpenFolder设置为true，其他图标为false，小文件夹关闭态没有图标
   * 1. 文件夹展开态图标退出需要判断isOpenFolder为true
   * 2. 非文件夹展开态，但是文件夹内的图标启动退出需要判断isOpenFolder为false
   * 3. neddCheckFolderApp为false时不判断isOpenFolder，比如小文件夹内图标启动后，应用退出时小文件夹被关闭，
   * 此时桌面上无法找到isOpenFolder为false的图标，会导致退出打断动效异常
   */
  private checkWithFolderApp(appData: AppData, neddCheckFolderApp: boolean): boolean {
    if (this.isOpeningFolder()) {
      return appData.isOpenFolder;
    } else if (neddCheckFolderApp) {
      return !appData.isOpenFolder;
    }
    return true;
  }

  private findTransitionControllerInList(findData: AppData, neddCheckFolderApp: boolean = true): SCBTransitionController {
    let item = this.transitionControllerList.find(item => {
      if (CheckEmptyUtils.isEmpty(item) || CheckEmptyUtils.isEmpty(item.appData)) {
        return false;
      }
      const appData = item.appData;
      if (findData.startAppType === StartType.SHORTCUT_MENU) {
        let short = this.isSameTransitionControllerForShortcutMenu(appData, findData);
        return short;
      }
      if (appData.startAppType !== findData.startAppType) {
        return false;
      }
      return this.isSameTransitionController(findData.startAppType, appData, findData, neddCheckFolderApp);
    });
    log.showWarn(`Find controller success ? ${!CheckEmptyUtils.isEmpty(item)}, findData: ${JSON.stringify(findData)}`);
    return this.getControllerItem(item, findData);
  }

  /**
   * 校验是否快捷图标启动
   * @param appData 待查询数据
   * @param findData 查询数据
   * @returns 匹配结果
   */
  private isSameTransitionControllerForShortcutMenu(appData: AppData,
    findData: AppData): boolean {
    // 筛选app和文件夹启动controller
    if (appData.startAppType !== StartType.APP && appData.startAppType !== StartType.FOLDER) {
      return false;
    }
    const compareNameAndIndexRes: boolean = appData.bundleName === findData.bundleName && appData.appIndex === findData.appIndex;
    // 在展开的文件夹内寻找controller
    if (findData.isOpenFolder) {
      return compareNameAndIndexRes && appData.isOpenFolder === findData.isOpenFolder;
    }
    // 如果匹配到controller则走桌面启动
    return compareNameAndIndexRes;
  }

  private isSameTransitionController(startType: StartType, appData: AppData,
    findData: AppData, neddCheckFolderApp: boolean): boolean {
    let isSameTransitionController = false;
    switch (startType) {
      case StartType.CARD:
        isSameTransitionController = appData.cardId === findData.cardId;
        break;
      case StartType.SHORTCUT_APP:
        isSameTransitionController = appData.bundleName === findData.bundleName &&
          appData.shortcutId === findData.shortcutId && appData.appIndex === findData.appIndex &&
          appData.isOuterDesktop === findData.isOuterDesktop &&
        this.checkWithFolderApp(appData, neddCheckFolderApp);
        break;
      case StartType.RECENT_DOCK_APP:
      case StartType.AI_SUGGESTION_APP:
        isSameTransitionController = appData.bundleName === findData.bundleName &&
          appData.appIndex === findData.appIndex && appData.extraId === findData.extraId;
        break;
      case StartType.SCREEN_LOCK_TOOLS:
        isSameTransitionController = appData?.bundleName === findData.bundleName &&
          appData?.abilityName === findData.abilityName && appData?.cardId === undefined;
        break;
      case StartType.FILE_FOLDER:
        isSameTransitionController = appData?.bundleName === findData.bundleName &&
          appData?.ino === findData.abilityName;
        break;
      case StartType.APP_CENTER_APP:
        isSameTransitionController = appData?.bundleName === findData.bundleName &&
          appData?.abilityName === findData.abilityName && appData?.extraId === findData.extraId &&
          appData.appIndex === findData.appIndex && this.checkWithFolderApp(appData, neddCheckFolderApp);
        if (isSameTransitionController && IntelligentCache.isIntelligentIconId(appData.appIconId)) {
          isSameTransitionController = IntelligentCache.getInstance().isCurrentIconId(appData.bundleName, appData.appIconId);
        }
        break;
      default:
        if (appData?.extraId === 'Desktop-AppItem') {
          isSameTransitionController = appData?.bundleName === findData.bundleName &&
            appData?.abilityName === findData.abilityName && appData.appIndex === findData.appIndex;
        } else {
          isSameTransitionController = appData.bundleName === findData.bundleName &&
            appData.abilityName === findData.abilityName && appData.extraId === undefined &&
            appData.appIndex === findData.appIndex && appData.isOuterDesktop === findData.isOuterDesktop &&
          this.checkWithFolderApp(appData, neddCheckFolderApp) && this.checkAppInstanceKey(appData, findData);
          isSameTransitionController =
            this.checkSameControllerWithProduct(isSameTransitionController, appData, findData, startType);
          if (isSameTransitionController && IntelligentCache.isIntelligentIconId(appData.appIconId)) {
            isSameTransitionController =
              IntelligentCache.getInstance().isCurrentIconId(appData.bundleName, appData.appIconId);
          }
        }
        break;
    }
    return isSameTransitionController;
  }

  private checkSameControllerWithProduct(isSameTransitionController: boolean, appData: AppData,
    findData: AppData, startType: StartType): boolean {
    if (isSameTransitionController) {
      const uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
      if (uiType === SCBConstants.UITYPE_PHONE) {
        isSameTransitionController = (appData.cardId === undefined);
      } else if (uiType === SCBConstants.UITYPE_PC || DeviceHelper.is2In1DevicePcType()) {
        if (appData.screenId === undefined) {
          log.showWarn(`appData screenId is undefined ${appData.bundleName}`);
          appData.screenId = 0;
        }
        if (findData.screenId === undefined) {
          log.showWarn(`findData screenId is undefined ${findData.bundleName}`);
          findData.screenId = 0;
        }
        isSameTransitionController = (appData.screenId === findData.screenId);
        if (isSameTransitionController && startType === StartType.DOCK_APP) {
          isSameTransitionController = ((appData.persistentId ?? '') === (findData.persistentId ?? ''));
        }
      }
    }
    return isSameTransitionController;
  }

  private checkAppInstanceKey(appData: AppData, findData: AppData): boolean {
    if (CheckEmptyUtils.checkStrIsEmpty(appData.appInstanceKey) && CheckEmptyUtils.checkStrIsEmpty(findData.appInstanceKey)) {
      return true;
    }
    if (!CheckEmptyUtils.checkStrIsEmpty(appData.appInstanceKey) && CheckEmptyUtils.isEmpty(findData.appInstanceKey)) {
      return false;
    }
    if (CheckEmptyUtils.checkStrIsEmpty(appData.appInstanceKey) && !CheckEmptyUtils.checkStrIsEmpty(findData.appInstanceKey)) {
      return false;
    }
    return appData.appInstanceKey === findData.appInstanceKey;
  }

  private getControllerItem(item: SCBTransitionController, findData: AppData): SCBTransitionController {
    if (CheckEmptyUtils.isEmpty(item)) {
      // 没有找到Controller，判断是OOBE包名，找OOBE对应的语音助手建议包名
      let oobeItem = this.findOobeTransitionController(findData);
      if (oobeItem) {
        return oobeItem;
      }
    }
    return item;
  }

  private findOobeTransitionController(findData: AppData): SCBTransitionController {
    if (this.isOobeBundleName(findData.bundleName)) {
      let item = this.getOobeControllerItem();
      if (item) {
        log.showInfo(`Find oobe controller success, bundleName=%{public}s abilityName=%{public}s appIconId=%{public}s`,
          item.appData.bundleName, item.appData.abilityName, item.appData.appIconId);
        return item;
      }
    }
    return null;
  }

  private getOobeControllerItem(): SCBTransitionController {
    // OOBE
    let item = this.transitionControllerList.find(item => {
      const appData = item.appData;
      // 语音助手建议卡片内部玩机技巧
      return appData.bundleName === SCBConstants.TIPS_BUNDLE_NAME && appData.startAppType === StartType.CARD &&
        !CheckEmptyUtils.isEmpty(appData.extraId);
    });
    if (!item) {
      item = this.transitionControllerList.find(item => {
        const appData = item.appData;
        const bundleName = appData.bundleName;
        // 语音助手建议卡片内部默认卡
        return bundleName === SCBConstants.AI_SUGGESTION_BUNDLE_NAME && appData.startAppType === StartType.CARD &&
          !CheckEmptyUtils.isEmpty(appData.extraId);
      });
    }
    return item;
  }

  /**
   * 通过图标组件id查找TransitionController
   * @param iconId
   * @param isOpenFolder
   * @returns
   */
  public findTransitionControllerWithIconId(iconId: string, isOpenFolder: boolean): SCBTransitionController {
    let findControllerList: SCBTransitionController[] = this.transitionControllerList.filter((item) => {
      return item?.appData?.appIconId === iconId;
    });
    let controller: SCBTransitionController = null;
    if (findControllerList.length === 1) {
      controller = findControllerList[0];
    } else if (findControllerList.length > 1) {
      // 文件夹展开态和折叠态的图标组件id相同，需要再次判断文件夹状态
      controller = findControllerList.find(item => item?.appData?.isOpenFolder === isOpenFolder);
    }
    log.showWarn(`Find controller success ? ${!controller}, appData: ${JSON.stringify(controller?.appData)}`);
    return controller;
  }

  public isOobeBundleName(bundleName: string): boolean {
    return SCBConstants.OOBE_PKG === bundleName;
  }

  registerAppExitToFolderController(controller: SCBAppExitToFolderController): void {
    if (controller === undefined || controller === null) {
      log.showError('registerAppExitToFolderController, controller null');
      return;
    }
    log.showInfo(`registerAppExitToFolderController folderKey: ${controller.folderKey}`);
    let item = this.appExitToFolderControllerList.find(item => {
      return item === controller || item.folderKey === controller.folderKey;
    });
    if (!item) {
      this.appExitToFolderControllerList.push(controller);
    }
    log.showInfo(`registerAppExitToFolderController length: ${this.appExitToFolderControllerList.length}`);
  }

  unRegisterAppExitToFolderController(controller: SCBAppExitToFolderController): void {
    if (controller === undefined || controller === null) {
      log.showError('unRegisterAppExitToFolderController, controller null');
      return;
    }
    let index = this.appExitToFolderControllerList.indexOf(controller);
    if (index === -1) {
      log.showWarn('unRegisterAppExitToFolderController failed, controller was not register');
    } else {
      this.appExitToFolderControllerList.splice(index, 1);
    }
    log.showInfo(`unRegisterAppExitToFolderController length: ${this.appExitToFolderControllerList.length}`);
  }

  runAppExitToFolderStartCallback(folderId: string, index: number): void {
    log.showInfo(`exitToFolderStart folderId: ${folderId}; index: ${index}`);
    this.appExitToFolderControllerList.forEach((item: SCBAppExitToFolderController) => {
      if (item?.folderKey?.startsWith(folderId)) {
        item?.onExitStart(folderId, index);
      }
    });
  }

  runAppExitToFolderEndCallback(folderId: string, index: number): void {
    log.showInfo(`exitToFolderEnd folderId: ${folderId}; index: ${index}`);
    this.appExitToFolderControllerList.forEach((item: SCBAppExitToFolderController) => {
      if (item?.folderKey?.startsWith(folderId)) {
        item?.onExitEnd(folderId, index);
      }
    });
  }

  runGlobalActiveCallback(isAnim: boolean, isLockNtfAnim?: boolean): void {
    if (isAnim) {
      this.globalTransitionControllerList.forEach((item: SCBTransitionController) => {
        item.onActive('runGlobalActiveCallback');
      });
    } else {
      this.globalTransitionControllerList.forEach((item: SCBTransitionController) => {
        if (item?.onActiveWithNoAnim && isLockNtfAnim === undefined) {
          item?.onActiveWithNoAnim();
        }
      });
    }
  }

  runGlobalInactiveCallback(isAnim: boolean = true, scaleDelayTime: number = 0): void {
    if (isAnim) {
      this.globalTransitionControllerList.forEach((item: SCBTransitionController) => {
        item.onInactive('runGlobalInactiveCallback', scaleDelayTime);
      });
    } else {
      this.globalTransitionControllerList.forEach((item: SCBTransitionController) => {
        if (item.onInactiveWithNoAnim) {
          item.onInactiveWithNoAnim('runGlobalInactiveCallback');
        }
      });
    }
  }

  // fold screen animation
  registerFoldAnimationController(controller: SCBFoldController): void {
    log.showInfo('registerFoldAnimationController');
    let item = this.foldAnimationControllerList.find(item => item === controller);
    if (!item) {
      this.foldAnimationControllerList.push(controller);
    }
  }

  unRegisterFoldAnimationController(controller: SCBFoldController): void {
    if (!controller) {
      log.showError('unRegisterFoldAnimationController, controller null');
      return;
    }
    let index = this.foldAnimationControllerList.indexOf(controller);
    if (index === -1) {
      log.showWarn('unRegisterFoldAnimationController failed, controller was not register');
    } else {
      this.foldAnimationControllerList.splice(index, 1);
    }
    log.showInfo('unRegisterFoldAnimationController foldAnimationControllerList length:' + this.foldAnimationControllerList.length);
  }

  runFoldAnimationCallback(): void {
    log.showInfo('runFoldAnimationCallback');
    this.foldAnimationControllerList.forEach((item: SCBFoldController) => {
      item.onFoldAnimation();
    });
  }

  registerExpandAnimationController(controller: SCBExpandController): void {
    log.showInfo('registerExpandAnimationController');
    let item = this.expandAnimationControllerList.find(item => item === controller);
    if (!item) {
      this.expandAnimationControllerList.push(controller);
    }
  }

  unRegisterExpandAnimationController(controller: SCBExpandController): void {
    if (!controller) {
      log.showError('unRegisterExpandAnimationController, controller null');
      return;
    }
    let index = this.expandAnimationControllerList.indexOf(controller);
    if (index === -1) {
      log.showWarn('unRegisterExpandAnimationController failed, controller was not register');
    } else {
      this.expandAnimationControllerList.splice(index, 1);
    }
    log.showInfo('unRegisterExpandAnimationController expandAnimationControllerList length:' + this.expandAnimationControllerList.length);
  }

  runExpandAnimationCallback(): void {
    log.showInfo('runExpandAnimationCallback');
    this.expandAnimationControllerList.forEach((item: SCBExpandController) => {
      item.onExpandAnimation();
    });
  }

  registerTripleAnimationController(controller: SCBTripleController): void {
    log.showInfo('registerTripleAnimationController, itemId = %{public}s', controller.itemId);
    let item = this.tripleAnimationControllerList.find(item => item === controller);
    if (!item) {
      this.tripleAnimationControllerList.push(controller);
    }
  }

  unRegisterTripleAnimationController(controller: SCBTripleController): void {
    if (!controller) {
      log.showError('unRegisterTripleAnimationController, controller null');
      return;
    }
    let index = this.tripleAnimationControllerList.indexOf(controller);
    if (index === -1) {
      log.showWarn('unRegisterTripleAnimationController failed, controller was not register');
    } else {
      this.tripleAnimationControllerList.splice(index, 1);
    }
    log.showInfo('unRegisterTripleAnimationController tripleAnimationControllerList length: %{public}d',
      this.tripleAnimationControllerList.length);
  }

  runTripleAnimationCallback(oldState: ScreenState, newState: ScreenState, isNeedAnimation: boolean = true): void {
    log.showInfo('runTripleAnimationCallback');
    this.tripleAnimationControllerList.forEach((item: SCBTripleController) => {
      log.showInfo('callback item: %{public}s', item.itemId);
      item.onTripleAnimation(oldState, newState, isNeedAnimation);
    });
  }

  notifySceneTransitionIn(controller: SCBTransitionController, isTransitionInFromOther: boolean, isAnim: boolean = true, isLockNtfAnim?: boolean): void {
    log.showWarn(`notifySceneTransitionIn isTransitionInFromOther: ${isTransitionInFromOther}`);
    this.runGlobalActiveCallback(isAnim, isLockNtfAnim);
    if (this.isNotSameBundleName(controller)) {
      log.showInfo('cancelCloseAppAnimate');
      this.cancelCloseAppAnimate();
    }
    if (this.currentTransitionController !== controller) {
      log.showInfo('change currentTransitionController');
      this.currentTransitionController?.onInactive(TAG, 'notifySceneTransitionIn');
      this.cleanTransition(this.currentTransitionController);
      // 启动场景执行动效打断会导致启动窗口无动效，需要清空动效打断函数
      this.cancelCloseAppAnimateFun = null;
      this.sceneContainerSession = null;
    }
    if (!isTransitionInFromOther) {
      controller?.onActive(TAG, 'notifySceneTransitionIn');
    }
    this.currentTransitionController = controller;
  }

  private isNotSameBundleName(controller: SCBTransitionController): boolean {
    let controllerBundleName = controller?.appData?.bundleName;
    let currentTransitionBundleName = this.currentTransitionController?.appData?.bundleName;
    if (!controllerBundleName || !currentTransitionBundleName) {
      return false;
    }
    if (controllerBundleName !== currentTransitionBundleName) {
      log.showInfo('isNotSameBundleName');
      return true;
    }
    log.showInfo('isSameBundleName');
    return false;
  }

  notifySceneTransitionOut(controller: SCBTransitionController, isTransitionOutToIcon: boolean): void {
    log.showWarn(`notifySceneTransitionOut isTransitionOutToIcon=${isTransitionOutToIcon}`);
    if (this.currentTransitionController === null && controller === null) {
      log.showInfo('no need to notifySceneTransitionOut');
      return;
    }
    this.runGlobalInactiveCallback();
    if (controller && this.currentTransitionController && this.currentTransitionController?.appData?.appIconId !== controller?.appData?.appIconId) {
      log.showInfo('notify transitionControllers inactive');
      this.currentTransitionController?.onInactive(TAG, 'notifySceneTransitionOut', 'currentTransitionController');
      controller?.onInactive(TAG, 'notifySceneTransitionOut', 'controller');
    }
    if (isTransitionOutToIcon) {
      controller?.onActive(TAG, 'notifySceneTransitionOut');
    }
    if (controller && this.currentTransitionController !== controller) {
      this.cleanTransition(this.currentTransitionController);
      this.currentTransitionController = controller;
    }
  }

  cancelCloseAppAnimate(): void {
    log.showInfo(`cancelCloseAppAnimate, cancelCloseAppAnimateFun is empty: ${!this.cancelCloseAppAnimateFun}`);
    this.cancelCloseAppAnimateFun?.(this.sceneContainerSession);
  }

  setCancelCloseAppAnimateFun(callback: Function, sceneContainerSession: SCBSceneContainerSession): void {
    this.cancelCloseAppAnimateFun = callback;
    this.sceneContainerSession = sceneContainerSession;
  }

  public cleanTransition(controller: SCBTransitionController): void {
    if (!controller) {
      log.showInfo('cleanTransition ignore');
      return;
    }
    if (!this.currentTransitionController) {
      log.showInfo('currentTransitionController is null');
      return;
    }
    const isCurrentController: boolean = this.currentTransitionController === controller;
    log.showInfo(`cleanTransition isCurrentController:${isCurrentController}, updateAnimSwipe: ` +
      `${!!this.currentTransitionController.updateAnimSwipe}`);
    if (!isCurrentController) {
      log.showInfo(`cleanTransition lastBundleName:${controller?.appData?.bundleName}` +
        `, currentBundleName:${this.currentTransitionController?.appData?.bundleName}`);
      return;
    }
    this.currentTransitionController.cancelAnim = null;
    this.currentTransitionController.updateAnimSwipe = null;
    this.currentTransitionController.updateAnimSwipeEnd = null;
    this.currentTransitionController = null;
  }

  public getCurrentTransitionController(): SCBTransitionController {
    return this.currentTransitionController;
  }

  registerTransitionCallback(eventId: number, callback: Function): void {
    let functions: Array<Function> = this.callbackMap.get(eventId);
    if (!functions) {
      functions = new Array<Function>();
    }
    functions.push(callback);
    this.callbackMap.set(eventId, functions);

    log.showInfo(`Register func type:${eventId} with success.functions.length:${functions.length}`);
  }

  unRegisterTransitionCallback(eventId: number, callback: Function): void {
    let functions: Array<Function> = this.callbackMap.get(eventId);
    if (CheckEmptyUtils.isEmpty(functions)) {
      return;
    }
    functions.splice(functions.indexOf(callback));
    this.callbackMap.set(eventId, functions);
    log.showInfo(`unRegister func type:${eventId} with success. functions.length:${functions.length}`);
  }

  public swipeUpFromHome(followValue: number): void {
    if (!this.callbackMap.has(SCBDesktopEventId.SWIPE_UP_FROM_HOME)) {
      return;
    }
    let functions = this.callbackMap.get(SCBDesktopEventId.SWIPE_UP_FROM_HOME);
    functions?.forEach((value: Function) => {
      value(followValue);
    });
  }

  public swipeUpBackHomeFromHome(followValue: number): void {
    if (!this.callbackMap.has(SCBDesktopEventId.SWIPE_UP_BACK_HOME_FROM_HOME)) {
      return;
    }
    let functions = this.callbackMap.get(SCBDesktopEventId.SWIPE_UP_BACK_HOME_FROM_HOME);
    functions?.forEach((value: Function) => {
      value(followValue);
    });
  }

  registerUnlockSpaceAniListener(listener: SCBUnlockSpaceAniListener): void {
    this.unlockSpaceAniListerner = listener;
  }

  unRegisterUnlockSpaceAniListener(): void {
    this.unlockSpaceAniListerner = null;
  }

  registerUnlockTransitionController(controller: SCBUnlockTransitionController | undefined, isHomeState: boolean): void {
    if (controller === undefined || controller === null) {
      log.showError('registerUnlockTransitionController, controller null');
      return;
    }
    if (isHomeState) {
      let item = this.unlockTransitionEnterHomeList.find(item => item === controller || item?.name === controller?.name);
      if (!item) {
        this.unlockTransitionEnterHomeList.push(controller);
      }
    } else {
      let item = this.unlockTransitionControllerList.find(item => item === controller || item?.name === controller?.name);
      if (!item) {
        this.unlockTransitionControllerList.push(controller);
      }
    }

    log.showInfo('registerUnlockTransitionController unlockTransitionControllerList length:' +
      this.unlockTransitionControllerList?.length + ' name: ' + controller.name);
  }

  unRegisterUnlockTransitionController(controller: SCBUnlockTransitionController | undefined, isHomeState: boolean): void {
    if (controller === undefined || controller === null) {
      log.showError('unRegisterUnlockTransitionController, controller null');
      return;
    }
    if (isHomeState) {
      let index = this.unlockTransitionEnterHomeList.indexOf(controller);
      if (index === -1) {
        log.showWarn('UnRegisterUnlockTransitionController failed, controller was not register');
      } else {
        this.unlockTransitionEnterHomeList.splice(index, 1);
      }
    } else {
      let index = this.unlockTransitionControllerList.indexOf(controller);
      if (index === -1) {
        log.showWarn('UnRegisterUnlockTransitionController failed, controller was not register');
      } else {
        this.unlockTransitionControllerList.splice(index, 1);
      }
    }

    log.showInfo('UnRegisterUnlockTransitionController unlockTransitionControllerList length:' + this.unlockTransitionControllerList?.length);
  }

  notifyUnlockTransition(): void {
    log.showInfo(`notifyUnlockTransition, length: ${this.unlockTransitionControllerList?.length},
     unlockTransitionEnterHomeList length: ${this.unlockTransitionEnterHomeList?.length}`);
    this.unlockTransitionControllerList.forEach((item: SCBUnlockTransitionController) => {
      if (item?.onUnlock) {
        item?.onUnlock();
      }
    });
  }

  notifyLockTransition(): void {
    log.showInfo(`notifyLockTransition, length: ${this.unlockTransitionControllerList?.length},
     unlockTransitionEnterHomeList length: ${this.unlockTransitionEnterHomeList?.length}`);
    this.unlockTransitionControllerList.forEach((item: SCBUnlockTransitionController) => {
      if (item?.onLock) {
        item?.onLock();
      }
    });
  }

  notifyUnlockStartScene(): void {
    log.showInfo(`notifyUnlockStartScene, length: ${this.unlockTransitionControllerList?.length},
     unlockTransitionEnterHomeList length: ${this.unlockTransitionEnterHomeList?.length}`);
    this.unlockTransitionControllerList.forEach((item: SCBUnlockTransitionController) => {
      if (item?.onUnlockStartScene) {
        item?.onUnlockStartScene();
      }
    });
  }

  notifyUnlockAnimation(): void {
    log.showInfo(`notifyUnlockAnimation, length: ${this.unlockTransitionControllerList?.length},
     unlockTransitionEnterHomeList length: ${this.unlockTransitionEnterHomeList?.length}`);
    this.unlockTransitionControllerList.forEach((item: SCBUnlockTransitionController) => {
      if (item?.onUnlockAnimation) {
        item?.onUnlockAnimation();
      }
    });
  }

  notifyUnlockSpaceAniFinished(): void {
    log.showInfo(`notifySpaceAniFinished`);
    this.unlockSpaceAniListerner?.onFinish();
  }

  onUnlockTransitionEnterHome(): void {
    this.unlockTransitionEnterHomeList.forEach((item: SCBUnlockTransitionController) => {
      if (item?.onUnlock) {
        item?.onUnlock();
      }
    });
  }

  onLockTransitionEnterHome(): void {
    this.unlockTransitionEnterHomeList.forEach((item: SCBUnlockTransitionController) => {
      if (item?.onUnlock) {
        item?.onLock();
      }
    });
  }

  registerScreenChangeTransitionController(controller: SCBScreenStateChangeTransitionController | undefined): void {
    if (controller === undefined || controller === null) {
      log.showError('registerScreenChangeTransitionController, controller null');
      return;
    }
    this.screenChangeTransitionControllerList.push(controller);
    log.showInfo('registerScreenChangeTransitionController screenChangeTransitionControllerList length:' +
      this.screenChangeTransitionControllerList?.length + ' name: ' + controller.name);
  }

  unRegisterScreenChangeTransitionController(controller: SCBScreenStateChangeTransitionController | undefined): void {
    if (controller === undefined || controller === null) {
      log.showError('unRegisterScreenChangeTransitionController, controller null');
      return;
    }
    let index = this.screenChangeTransitionControllerList.indexOf(controller);
    if (index === -1) {
      log.showWarn('unRegisterScreenChangeTransitionController failed, controller was not register');
    } else {
      this.screenChangeTransitionControllerList.splice(index, 1);
    }

    log.showInfo('unRegisterScreenChangeTransitionController screenChangeTransitionControllerList length:' +
      this.screenChangeTransitionControllerList?.length);
  }

  notifyBeginScreenOnTransition(): void {
    log.showInfo('notifyBeginScreenOnTransition, length:' + this.unlockTransitionControllerList?.length);
    this.screenChangeTransitionControllerList.forEach((item: SCBScreenStateChangeTransitionController) => {
      if (item?.beginScreenOn) {
        item?.beginScreenOn();
      }
    });
  }

  notifyEndScreenOnTransition(): void {
    log.showInfo('notifyEndScreenOnTransition, length:' + this.unlockTransitionControllerList?.length);
    this.screenChangeTransitionControllerList.forEach((item: SCBScreenStateChangeTransitionController) => {
      if (item?.endScreenOn) {
        item?.endScreenOn();
      }
    });
  }

  notifyScreenOffTransition(): void {
    log.showInfo(' notifyScreenOffTransition, length:' + this.unlockTransitionControllerList?.length);
    this.screenChangeTransitionControllerList.forEach((item: SCBScreenStateChangeTransitionController) => {
      if (item?.screenOff) {
        item?.screenOff();
      }
    });
  }

  public getTransitionCount(containerId: string): number {
    let transitionAnimationCount = this.animationMap.get(containerId) ?? 0;
    if (transitionAnimationCount !== 0) {
      log.showWarn(`getTransitionCount from animationMap ${containerId}, ${transitionAnimationCount}`);
    }
    return transitionAnimationCount;
  }

  public addTransitionCount(containerId: string): void {
    let transitionAnimationCount = this.animationMap.get(containerId) ?? 0;
    log.showInfo(`Add count ${containerId}, ${transitionAnimationCount}`);
    this.animationMap.set(containerId, ++transitionAnimationCount);
  }

  public clearTransitionCount(containerId: string): void {
    log.showInfo(`clearTransitionCount ${containerId}, ${this.animationMap.get(containerId)}`);
    this.animationMap.delete(containerId);
  }

  /**
   * 更改关闭动画
   * @param swipeOffset 每一帧swiper的偏移
   * @param isAniToEnd 是否离手
   */
  public updateCloseAppAnimate(swipeOffset: number, isAniToEnd: boolean = false): void {
    const controller: SCBTransitionController = this.currentTransitionController;
    if (controller?.updateAnimSwipe) {
      if (this.isExitSwipeIng) {
        this.cancelCloseAppAnimate();
        return;
      }
      if (isAniToEnd) {
        this.isExitSwipeIng = isAniToEnd;
      }
      const offsetChanged = swipeOffset - this.lastSwipeOffset;
      if (offsetChanged === 0) {
        log.showDebug('swipe offset not changed');
        return;
      }
      if (this.lastSwipeOffsetChanged !== 0 && offsetChanged < 0 !== this.lastSwipeOffsetChanged < 0) {
        // swipe direction changed
        log.showInfo(`swipe direction changed ${swipeOffset}`);
        return;
      }
      this.lastSwipeOffset = swipeOffset;
      this.lastSwipeOffsetChanged = offsetChanged;
      controller.updateAnimSwipe(swipeOffset, isAniToEnd);
    }
  }

  /**
   * 处理退出后立即滑动的动效
   * @param targetIndex 目标页
   * @param index 当前页
   */
  public handleSwipeToEnd(targetIndex: number, index: number): void {
    // 向前翻页，向后翻页，回弹效果
    const screenWidth: number = AppStorage.get('screenWidth') as number;
    if (targetIndex === index) {
      this.updateCloseAppAnimate(0, true);
    } else if (targetIndex > index) {
      this.updateCloseAppAnimate(-screenWidth, true);
    } else {
      this.updateCloseAppAnimate(screenWidth, true);
    }
  }

  public getIsExclusiveSwiperElementsCancelAnimate(): boolean {
    return this.isExclusiveSwiperElementsCancelAnimate;
  }

  public setIsExclusiveSwiperElementsCancelAnimate(isExclusiveCancelAnimate: boolean) : void {
    this.isExclusiveSwiperElementsCancelAnimate = isExclusiveCancelAnimate;
  }
}

/**
 * unlock transition controller
 */
export interface SCBUnlockTransitionController {
  name: string;

  onLock: () => void;

  onUnlockStartScene?: () => void; // 用于拉起前台应用

  onUnlockAnimation?: () => void; // 前台应用解锁动效

  onUnlock: () => void;
}

export interface SCBUnlockSpaceAniListener {
  onFinish: () => void;
}

/**
 * screen state change transition controller
 */
export interface SCBScreenStateChangeTransitionController {
  name: string;

  beginScreenOn: () => void;

  endScreenOn: () => void;

  screenOff: () => void;
}
