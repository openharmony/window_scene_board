/**
 * Copyright (c) 2023-2023 Huawei Device Co., Ltd.
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

import { CompanionIconForPC, CompanionIconViewModel, CompanionIconViewList } from './CompanionIconForPC';
import HoverEffectConstants from '@ohos/pcsmartdock/src/main/ets/default/common/constants/HoverEffectConstants';
import { CommonConstants, StyleConstants } from '@ohos/launchercommon'
import {
  SCBTransitionController,
  SCBScreenProperty,
  SCBTransitionManager,
  SCBSceneSessionManager,
  SCBPropertyChangeReason,
  SCBScreenSessionManager
} from '@ohos/windowscene';
import { SCBCompanionManager, SCBCompanionController } from '@ohos/windowscene/Index';
import { Log, StartType, CompanionIconInfo, SingleContext } from '@ohos/basicutils';
import { ApsUtils, ViewArea, viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';

import curves from '@ohos.curves';
import HashMap from '@ohos.util.HashMap';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import { JSON } from '@kit.ArkTS';
import { PCDockDragMgr } from '@ohos/pcsmartdock/src/main/ets/default/manager/PCDockDragMgr';
import { BaseViewController } from '@ohos/frameworkcommon/src/main/ets/TsIndex';
import { SystemAnimatedScene, systemAniSceneCtrl } from '@ohos/pcmode';
import { PcDockAnimationMgr } from '@ohos/pcsmartdock/src/main/ets/default/manager/PcDockAnimationMgr';
import { AppIconData } from '@ohos/launchercommon/Index';

const TAG = 'SCBCompanionView';
const CARD_FW_ANIMATOR_DURATION = 120;
const APP_FW_ANIMATOR_DURATION = 150;
const DEFAULT_ICON_SCALE = 1.5;
const LARGE_ICON_SCALE = 1.15;

@Component
export struct SCBCompanionView {
  @Link screenProp: SCBScreenProperty;
  @State singleContext?: SingleContext = { extendScreenId: this.screenProp.screenId };
  @StorageLink('dockHoverConfig') dockHoverConfig: HashMap<string, Object> = new HashMap();
  @State compIconViewList: CompanionIconViewList = new CompanionIconViewList();
  @State viewController: BaseViewController | undefined = undefined;
  persistentId: number = 0;
  private viewType: string = 'SCBCompanionView0';
  private transitionController?: SCBTransitionController;
  private mPCDockDragMgr: PCDockDragMgr = PCDockDragMgr.getInstance();
  private mDockAnimationMgr: PcDockAnimationMgr = PcDockAnimationMgr.getInstance(this.screenProp.screenId);
  @State iconData: AppIconData = new AppIconData();
  private onScreenPropertyChange = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    this.updateArea(screenProperty);
  }

  private updateArea(screenProperty: SCBScreenProperty): void {
    if (!this.viewController) {
      return;
    }
    const newVpRect: ViewArea = {
      left: 0,
      top: 0,
      width: px2vp(screenProperty.width),
      height: px2vp(screenProperty.height)
    };
    this.viewController.updateArea(newVpRect);
    this.viewController.updateRect(newVpRect);
  }

  aboutToAppear() {
    Log.showInfo(TAG, 'aboutToAppear');
    this.viewType = 'SCBCompanionView' + this.screenProp.screenId;
    this.viewController = new BaseViewController(this.viewType, this.screenProp.screenId);
    viewMgrPolicy.registerViewController(this.viewType, this.viewController);
    this.viewController.updateId(this.persistentId);
    this.updateArea(this.screenProp);
    SCBScreenSessionManager.getInstance()
      .registerScreenPropertyChangeCallbacks(this.onScreenPropertyChange, this.screenProp.screenId);
    this.transitionController = {
      appData: {
        bundleName: 'SCBCompanionView',
        abilityName: '',
        appIconId: '',
        appIconNumber: 0,
        iconRadius: 0,
        startAppType: StartType.APP,
        appIndex: 0,
        screenId: this.screenProp.screenId
      },
      onActive: () => Function,
      onInactive: () => Function,
      forward: (want?: HashMap<string, number | string>): void =>
        this.compIconAnimationForward(want as HashMap<string, number | string>),
      backward: (want?: HashMap<string, number | string>): void =>
        this.compIconAnimationBackward(want as HashMap<string, number | string>),
    };
    SCBTransitionManager.getInstance()
      .registerTransitionController(this.transitionController as SCBTransitionController);
    let controller: SCBCompanionController = {
      update: (compInfo: CompanionIconInfo): void => this.addCompIconView(compInfo),
      quickAdd: (compInfo: CompanionIconInfo): () => void => this.quickAddCompIconView(compInfo),
      delete: (compInfo: CompanionIconInfo): void => this.removeCompIconViewByInfo(compInfo)
    };
    SCBCompanionManager.getInstance().registerController(controller, this.screenProp.screenId);
    let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(
      this.persistentId, this.screenProp.screenId);
    if (systemSceneSession) {
      systemSceneSession.setSessionTouchable(false);
    }
  }

  aboutToDisappear() {
    Log.showInfo(TAG, 'aboutToDisappear');
    SCBTransitionManager.getInstance()
      .unRegisterTransitionController(this.transitionController as SCBTransitionController);
    SCBCompanionManager.getInstance().unRegisterController(this.screenProp.screenId);
    viewMgrPolicy.unregisterViewController(this.viewType);
    SCBScreenSessionManager.getInstance()
      .unRegisterScreenPropertyChangeCallbacks(this.onScreenPropertyChange, this.screenProp.screenId);
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      ForEach(this.compIconViewList, (item: CompanionIconViewModel) => {
        CompanionIconForPC({
          iconView: item,
          iconData: this.iconData,
          screenProp: $screenProp,
          singleContext: this.singleContext
        })
      }, (item: CompanionIconViewModel) => {
        let companionIconInfo = item.companionIconInfo;
        if (companionIconInfo) {
          return companionIconInfo.bundleName + '_' + companionIconInfo.abilityName + '_' + companionIconInfo.extraId;
        } else {
          return JSON.stringify(item);
        }
      })
    }
    .size({ width: px2vp(this.screenProp.width), height: px2vp(this.screenProp.height) })
    .hitTestBehavior(HitTestMode.None)
  }

  private getCompIconView(bundleName: string, abilityName: string,
    containerId: number | string): CompanionIconViewModel | undefined {
    return this.compIconViewList.find((item) => {
      return item?.companionIconInfo?.bundleName === bundleName &&
        item?.companionIconInfo?.abilityName === abilityName &&
        item?.companionIconInfo?.extraId === String(containerId);
    });
  }

  private removeCompIconViewByInfo(compInfo: CompanionIconInfo): void {
    let found = this.getCompIconView(compInfo?.bundleName, compInfo?.abilityName, compInfo?.extraId as string);
    if (found) {
      this.removeCompIconView(found);
    }
  }

  private removeCompIconView(curCompIconViewModel: CompanionIconViewModel): void {
    let bundleName = curCompIconViewModel?.companionIconInfo?.bundleName;
    let abilityName = curCompIconViewModel?.companionIconInfo?.abilityName;
    let containerId = curCompIconViewModel?.companionIconInfo?.extraId;
    curCompIconViewModel.animCount --;
    if (curCompIconViewModel.animCount > 0) {
      return;
    }
    curCompIconViewModel.setInitState();
    let index = this.compIconViewList.findIndex((item) => {
      return item?.companionIconInfo?.bundleName === bundleName &&
        item?.companionIconInfo?.abilityName === abilityName &&
        item?.companionIconInfo?.extraId === containerId;
    });
    if (index !== -1) {
      Log.showInfo(TAG, `remove companion, bundleName:${this.compIconViewList[index].companionIconInfo?.bundleName},` +
        ` abilityName:${this.compIconViewList[index].companionIconInfo?.abilityName}`);
      this.compIconViewList.splice(index, 1);
    } else {
      Log.showInfo(TAG, `remove companion failed, bundleName:${bundleName},` +
        ` abilityName:${abilityName},` + `extraId:${containerId}`);
    }
  }

  private compIconAnimationForward(want: HashMap<string, number | string>): void {
    let compIconViewModel = this.getCompIconView(want.get('bundleName') as string, want.get('abilityName') as string, want.get('containerId') as number);
    if (!compIconViewModel) {
      return;
    }
    let curCompIconViewModel = compIconViewModel as CompanionIconViewModel;
    curCompIconViewModel.iconWidth = want.get('width') as number;
    curCompIconViewModel.iconHeight = want.get('height') as number;
    curCompIconViewModel.iconPosX = want.get('posX') as number;
    curCompIconViewModel.iconPosY = want.get('posY') as number;
    curCompIconViewModel.iconFixSize = 0;
    curCompIconViewModel.animCount ++;
    curCompIconViewModel.setInitState();
    curCompIconViewModel.iconRadius = curCompIconViewModel.getRadius();
    curCompIconViewModel.iconVisible = true;
    curCompIconViewModel.appIndex = want.get('appIndex') as number;
    let animationDuration: number = APP_FW_ANIMATOR_DURATION;
    let iconScale: number = DEFAULT_ICON_SCALE;
    if (curCompIconViewModel.companionIconInfo?.startAppType === StartType.CARD) {
      animationDuration = CARD_FW_ANIMATOR_DURATION;
      if (curCompIconViewModel.companionIconInfo?.cardDimension === FormDimension.Dimension_4_4) {
        iconScale = LARGE_ICON_SCALE;
      }
    }
    let isHover = this.dockHoverConfig.get('isHover') as boolean;
    let hoverScale = isHover ? HoverEffectConstants.FIXED_HOVER_MASTER_SCALE : 1.0;
    let scaleX = want.get('scaleX') as number;
    let scaleY = want.get('scaleY') as number;
    let tranX = want.get('translateX') as number;
    let tranY = want.get('translateY') as number;
    let sceneRadius = want.get('sceneRadius') as number;
    let scale = Math.min(scaleX, scaleY);
    curCompIconViewModel.persistentId = (want.get('persistentId') ?? '') as string;
    animateTo({
      curve: curves.interpolatingSpring(0, 1, 228, 28),
      onFinish: () => {
        this.removeCompIconView(curCompIconViewModel);
      }
    }, () => {
      curCompIconViewModel.setTran(tranX, tranY);
    })
    animateTo({
      curve: scale === scaleX ? curves.interpolatingSpring(0, 1, 228, 28) :
      curves.interpolatingSpring(0, 1, 171, 23),
    }, () => {
      curCompIconViewModel.iconScaleX = scaleX / hoverScale;
    })
    animateTo({
      curve: scale === scaleY ? curves.interpolatingSpring(0, 1, 228, 28) :
      curves.interpolatingSpring(0, 1, 171, 23),
    }, () => {
      curCompIconViewModel.iconScaleY = scaleY / hoverScale;
    })
    animateTo({
      delay: 34,
      duration: 34,
      curve: Curve.Linear
    }, () => {
      curCompIconViewModel.iconAlpha = 0.0;
    })
    animateTo({
      curve: curves.cubicBezierCurve(0.2, 0.35, 0.2, 1.0),
      duration: 80
    }, () => {
      curCompIconViewModel.iconRadius = sceneRadius / scale;
    })
  }

  private compIconAnimationBackward(want: HashMap<string, number | string>): void {
    let isDropAnimationGoing = AppStorage.get<boolean>('isDropAnimationGoing');
    let compIconViewModel = this.getCompIconView(want.get('bundleName') as string, want.get('abilityName') as string,
      want.get('containerId') as number);
    if (!compIconViewModel) {
      Log.showInfo(TAG, 'compIconAnimationBackward compIconViewModel invalid');
      return;
    }
    let curCompIconViewModel = compIconViewModel as CompanionIconViewModel;
    let keyName = want.get('keyName') as string;
    let scaleX: number = (want.get('scaleX') ?? 1.0) as number;
    let scaleY: number = (want.get('scaleY') ?? 1.0) as number;
    let isMinimize: string = want.get('isMinimize') as string;
    let isHover = this.dockHoverConfig.get('isHover') as boolean;
    let sceneRadius = want.get('sceneRadius') as number;
    let isBottomInBScreen = want.get('isBottomInBScreen') === 'yes';
    let scale = Math.min(scaleX, scaleY);
    curCompIconViewModel.iconWidth = want.get('width') as number;
    curCompIconViewModel.iconHeight = want.get('height') as number;
    curCompIconViewModel.iconPosX = want.get('posX') as number;
    curCompIconViewModel.iconPosY = want.get('posY') as number;
    curCompIconViewModel.iconAlpha = 0.0;
    curCompIconViewModel.iconFixSize = 0;
    this.iconData = this.mDockAnimationMgr.getIconData(keyName);
    curCompIconViewModel.animCount ++;
    curCompIconViewModel.appIndex = want.get('appIndex') as number;
    curCompIconViewModel.setEndState(want.get('translateX') as number, want.get('translateY') as number);
    if (isBottomInBScreen) {
      curCompIconViewModel.iconScaleX = scale;
      curCompIconViewModel.iconScaleY = scale;
    } else {
      curCompIconViewModel.iconScaleX = scaleX;
      curCompIconViewModel.iconScaleY = scaleY;
    }
    const delayRemove: number = (want.get('delayRemove') ?? 0) as number;
    if (isMinimize === 'yes') {
      curCompIconViewModel.iconRadius = sceneRadius / scale;
    } else {
      curCompIconViewModel.iconRadius = want.get('iconRadius') as number ?? curCompIconViewModel.getRadius();
    }
    curCompIconViewModel.persistentId = (want.get('persistentId') ?? '') as string;
    if (want.get('typeId') === CommonConstants.TYPE_SHORTCUT_ICON && (!!curCompIconViewModel.companionIconInfo?.shortcutId)) {
      curCompIconViewModel.iconTypeId = CommonConstants.TYPE_SHORTCUT_ICON;
      curCompIconViewModel.iconResource = (want.get('iconResource') ?? '') as string;
    }
    curCompIconViewModel.startType = (want.get('startType') ?? StartType.APP) as StartType;
    if (isMinimize) {
      curCompIconViewModel.startType = StartType.DOCK_APP;
    }

    let isStatusBarDrag: boolean = (curCompIconViewModel.companionIconInfo?.startAppType === StartType.STATUS_BAR_TRAY);
    Log.showInfo(TAG, `compIconAnimationBackward ${isDropAnimationGoing}, ${isStatusBarDrag}`);
    if (isDropAnimationGoing) {
      animateTo({
        curve: isStatusBarDrag ? curves.interpolatingSpring(0, 1, 660, 66) : curves.interpolatingSpring(0, 1, 342, 37),
        onFinish: () => {
          AppStorage.setOrCreate<boolean>('isDropAnimationGoing', false);
          if (isStatusBarDrag && delayRemove === 1) {
            setTimeout(() => {
              this.removeCompIconView(curCompIconViewModel);
            }, 500); // 正式情况下是等PluginComponent渲染完成后通知移除，这里不会生效，这里延迟500ms是为了保证异常场景下也能保证移除提高健壮性
          } else {
            this.removeCompIconView(curCompIconViewModel);
          }
        }
      }, () => {
        curCompIconViewModel.iconScaleX = 1.0;
        curCompIconViewModel.iconScaleY = 1.0;
        curCompIconViewModel.setTran(0, 0);
        curCompIconViewModel.iconRadius = want.get('targetIconRadius') as number ?? curCompIconViewModel.iconRadius;
      });
      curCompIconViewModel.iconAlpha = 1.0;
    } else {
      animateTo({
        curve: curves.interpolatingSpring(0, 1, 228, 26),
        onFinish: () => {
          this.removeCompIconView(curCompIconViewModel);
          performanceMonitor.end('WINDOW_TITLE_BAR_MINIMIZED');
          // ApsUtils.setApsScene(apsManager.SceneAnimation.WINDOW_MIN, StyleConstants.DEFAULT_0);
          systemAniSceneCtrl.dequeue(SystemAnimatedScene.ENTER_MIN_WINDOW);
          want.set('isMinimize', 'no');
        }
      }, () => {
        curCompIconViewModel.setTran(0, 0);
      });
      if (isBottomInBScreen) {
        animateTo({
          curve: curves.interpolatingSpring(0, 1, 300, 32)
        }, () => {
          curCompIconViewModel.iconScaleX = 1.0;
          curCompIconViewModel.iconScaleY = 1.0;
        });
      } else {
        animateTo({
          curve: scale === scaleX ? curves.interpolatingSpring(0, 1, 300, 31) :
          curves.interpolatingSpring(0, 1, 363, 34),
        }, () => {
          curCompIconViewModel.iconScaleX = 1.0;
        });
        animateTo({
          curve: scale === scaleY ? curves.interpolatingSpring(0, 1, 300, 31) :
          curves.interpolatingSpring(0, 1, 363, 34),
        }, () => {
          curCompIconViewModel.iconScaleY = 1.0;
        });
      }
      animateTo({
        delay: isBottomInBScreen ? 260 : 150,
        duration: isBottomInBScreen ? 20 : 70,
        curve: Curve.Linear,
      }, () => {
        curCompIconViewModel.iconAlpha = 1.0;
      });
      animateToImmediately({
        curve: curves.cubicBezierCurve(1, 0, 1, 1),
        duration: 280
      }, () => {
        curCompIconViewModel.iconRadius = curCompIconViewModel.getRadius();
      });
    }
  }

  private addCompIconView(compInfo: CompanionIconInfo) {
    let found = this.getCompIconView(compInfo?.bundleName, compInfo?.abilityName, compInfo?.extraId as string);
    if (!found) {
      Log.showInfo(TAG, `add companion, bundleName:${compInfo?.bundleName}, abilityName:${compInfo?.abilityName},` +
        ` containerId:${compInfo?.extraId}`);
      let compIconView: CompanionIconViewModel = new CompanionIconViewModel();
      compIconView.companionIconInfo = compInfo;
      this.compIconViewList.push(compIconView);
    }
  }

  private quickAddCompIconView(compInfo: CompanionIconInfo): () => void {
    let found = this.getCompIconView(compInfo?.bundleName, compInfo?.abilityName, compInfo?.extraId as string);
    if (!found) {
      Log.showInfo(TAG, `add companion, bundleName:${compInfo?.bundleName}, abilityName:${compInfo?.abilityName},` +
        ` containerId:${compInfo?.extraId}`);
      found = new CompanionIconViewModel();
      found.companionIconInfo = compInfo;
      this.compIconViewList.push(found);
    }
    let callback = () => {
      if (!found) {
        Log.showError(TAG, `quickAddCompIconView vm not found`);
        return;
      }
      this.removeCompIconView(found);
    }
    return callback;
  }
}