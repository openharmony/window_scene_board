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

import { BaseViewController } from '@ohos/frameworkcommon';
import { SCBConstants } from '@ohos/commonconstants';
import {
  LogDomain,
  LogHelper,
  Observer,
} from '@ohos/basicutils';
import {
  EventManager,
  EvtBus,
  HiSysEventUtil,
  ViewController,
  viewMgrPolicy,
  ViewType,
  localEventManager,
  ViewCallback,
} from '@ohos/frameworkwrapper';
import {
  SCBScreenProperty,
  SCBSceneSessionManager,
  SCBScreenSessionManager,
  SCBPropertyChangeReason,
} from '@ohos/windowscene';
import { EventConstants } from '@ohos/launchercommon';
import screenLockMediator from '../../screenlock/refactor/ScreenLockMediator';
import { MultiKeyCode, MultimodalInputManager, } from '@ohos/systemuicommon';
import { SCBDefaultZIndex } from '../../scenemanager/SCBScreen';
import Constants from '../common/Constants';
import ctrlAltDelPanelModel from '../model/CtrlAltDelPanelModel';
import { CancelView } from './CancelView';
import { FunctionItemView } from './FunctionItemView';
import { SCBCtrlAltDelLayoutViewData } from '../viewmodel/SCBCtrlAltDelLayoutViewData';
import { SCBCtrlAltDelLayoutViewModel } from '../viewmodel/SCBCtrlAltDelLayoutViewModel';
import { FunctionListInfo, FunctionListSize } from '../common/FunctionListInfo';

const TAG = 'SCBCtrlAltDelPanel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

@Component
export struct SCBCtrlAltDelPanel {
  @State layoutViewData: SCBCtrlAltDelLayoutViewData = new SCBCtrlAltDelLayoutViewData();
  persistentId: number = 0;
  @Link screenProp: SCBScreenProperty;
  @State viewController: BaseViewController = new BaseViewController(ViewType.CTRL_ALT_DEL_PANEL);
  @StorageLink('isCtrlAltDelPanelShow') @Watch('updateCtrlAltDelPanelShow') isCtrlAltDelPanelShow: boolean = false;
  private eventMgr: EventManager = EvtBus.createEventManager();
  private screenLockObserver: Observer | null = null;
  private diagonalLength: number = 0;
  private layoutViewModel: SCBCtrlAltDelLayoutViewModel = new SCBCtrlAltDelLayoutViewModel();
  @State leftRightPadding: number = 0;
  @State topBottomPadding: number = 0;
  @StorageLink('systemLanguage') language: string = '';
  @State languageJustify: boolean = false;
  @State functionListSize: FunctionListSize = {
    textWidth: Constants.FUNCTION_TEXT_WIDTH,
    itemWidth: Constants.FUNCTION_ITEM_WIDTH,
    itemHeight: Constants.FUNCTION_ITEM_HEIGHT
  };

  private viewCallback: ViewCallback = {
    onShow: () => {
      ctrlAltDelPanelModel?.registerKeyInCtrlAltDelPanel();
    },
    onHide: () => {
      ctrlAltDelPanelModel?.unRegisterKeyInCtrlAltDelPanel();
    }
  };

  private listSizeJustify(): void {
    this.languageJustify = this.language.slice(0, 2) === 'ru';
    this.functionListSize = {
      textWidth: this.languageJustify ? Constants.FUNCTION_TEXT_WIDTH_LG : Constants.FUNCTION_TEXT_WIDTH,
      itemWidth: this.languageJustify ? Constants.FUNCTION_ITEM_WIDTH_LG : Constants.FUNCTION_ITEM_WIDTH,
      itemHeight: this.languageJustify ? Constants.FUNCTION_ITEM_HEIGHT_LG : Constants.FUNCTION_ITEM_HEIGHT
    }
  }

  private zoomWallpaperOnHopper(defaultSize: number): number {
    return defaultSize;
  }

  private updateCtrlAltDelPanelShow(): void {
    this.isCtrlAltDelPanelShow = AppStorage.get<boolean>('isCtrlAltDelPanelShow') as boolean;
    this.listSizeJustify();
    log.showInfo(`updateCtrlAltDelPanelShow isCtrlAltDelShow: ${this.isCtrlAltDelPanelShow}`);
    this.updateCtrlAltDelPanelRect();
    if (this.isCtrlAltDelPanelShow) {
      this.setWallpaperIndexToHideDesktop();
      this.viewController.show();
      // notify system dialog to close
      localEventManager.sendLocalEvent(EventConstants.EVENT_FORCE_CLOSE_ALL_SYS_DIALOG);
    } else {
      this.setWallpaperIndexToShowDesktop();
      this.viewController.hide();
    }
  }

  private setWallpaperIndexToHideDesktop(): void {
    let controller: ViewController | undefined = viewMgrPolicy.getViewController(ViewType.WALLPAPER);
    controller?.setZIndex(SCBDefaultZIndex.CTRL_ALT_DEL_PANEL - 1);
    log.showInfo('setWallpaperIndexToHideDesktop');
  }

  private setWallpaperIndexToShowDesktop(): void {
    let controller: ViewController | undefined = viewMgrPolicy.getViewController(ViewType.WALLPAPER);
    controller?.setZIndex(SCBDefaultZIndex.WALLPAPER);
    log.showInfo('setWallpaperIndexToHideDesktop');
  }

  private updateCtrlAltDelPanelRect(): void {
    this.listSizeJustify();
    this.viewController?.updateArea({
      left: -this.leftRightPadding,
      top: -this.topBottomPadding,
      width: px2vp(this.zoomWallpaperOnHopper(this.screenProp.width)),
      height: px2vp(this.zoomWallpaperOnHopper(this.screenProp.height))
    });
    this.viewController?.updateRect({
      left: -this.leftRightPadding,
      top: -this.topBottomPadding,
      width: px2vp(this.zoomWallpaperOnHopper(this.screenProp.width)),
      height: px2vp(this.zoomWallpaperOnHopper(this.screenProp.height))
    });
  }

  aboutToAppear() {
    log.showInfo(`aboutToAppear screen width: ${this.screenProp?.width}, screen height: ${this.screenProp?.height}`);
    this.listSizeJustify();
    viewMgrPolicy.registerViewController(ViewType.CTRL_ALT_DEL_PANEL, this.viewController);
    this.viewController.updateId(this.persistentId);
    this.viewController.registerCallback(this.viewCallback);
    this.initWindowPolicy();
    this.registerTransparentDetection();
    this.layoutViewData = this.layoutViewModel.initLayoutData();
    this.layoutViewData.functionMarginTop = (px2vp(this.screenProp?.height) -
      ctrlAltDelPanelModel.functionList.length * (this.functionListSize.itemHeight + Constants.FUNCTION_ITEM_GAP) +
      Constants.FUNCTION_ITEM_GAP) / 2;
    this.layoutViewData.cancelViewMarginTop = this.layoutViewData.functionMarginTop - Constants.CANCLE_VIEW_HEIGHT -
    Constants.CANCLE_VIEW_MARGIN_BOTTOM;
    this.layoutViewModel.registerFoldStateListener(this);
    SCBScreenSessionManager.getInstance().registerScreenPropertyChangeCallbacks(this.screenPropertyChangeCallBack, 
    this.screenProp.screenId);
  }

  private screenPropertyChangeCallBack = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    this.listSizeJustify();
    this.leftRightPadding = 0;
    this.topBottomPadding = 0;
    let height: number = screenProperty?.height ?? 0;
    this.layoutViewData.functionMarginTop = (px2vp(height) -
      ctrlAltDelPanelModel.functionList.length * (Constants.FUNCTION_ITEM_HEIGHT + Constants.FUNCTION_ITEM_GAP) +
    Constants.FUNCTION_ITEM_GAP) / 2;
    this.layoutViewData.cancelViewMarginTop = this.layoutViewData.functionMarginTop - Constants.CANCLE_VIEW_HEIGHT -
    Constants.CANCLE_VIEW_MARGIN_BOTTOM;
    this.updateCtrlAltDelPanelRect();
  };

  onFoldStateChange(layoutVD: SCBCtrlAltDelLayoutViewData): void {
    this.layoutViewData = layoutVD;
  }

  private initWindowPolicy() {
    log.showInfo(`init System panel window Policy`);
    this.eventMgr.addOff(MultimodalInputManager
      .subscribeCombinationKey([MultiKeyCode.CTRL_LEFT, MultiKeyCode.ALT_LEFT, MultiKeyCode.FORWARD_DEL],
        true, (data) => {
          log.showInfo(TAG, `on CombinationKeyEvent: data: ${JSON.stringify(data)}`);
          ctrlAltDelPanelModel?.ctlAltDelCallBack();
        }))
      .addOff(MultimodalInputManager
        .subscribeCombinationKey([MultiKeyCode.CTRL_LEFT, MultiKeyCode.ALT_RIGHT, MultiKeyCode.FORWARD_DEL],
          true, (data) => {
            log.showInfo(TAG, `on CombinationKeyEvent: data: ${JSON.stringify(data)}`);
            ctrlAltDelPanelModel?.ctlAltDelCallBack();
          }))
      .addOff(MultimodalInputManager
        .subscribeCombinationKey([MultiKeyCode.CTRL_RIGHT, MultiKeyCode.ALT_LEFT, MultiKeyCode.FORWARD_DEL],
          true, (data) => {
            log.showInfo(TAG, `on CombinationKeyEvent: data: ${data}`);
            ctrlAltDelPanelModel?.ctlAltDelCallBack();
          }))
      .addOff(MultimodalInputManager
        .subscribeCombinationKey([MultiKeyCode.CTRL_RIGHT, MultiKeyCode.ALT_RIGHT, MultiKeyCode.FORWARD_DEL],
          true, (data) => {
            log.showInfo(TAG, `on CombinationKeyEvent: data: ${data}`);
            ctrlAltDelPanelModel?.ctlAltDelCallBack();
          }))
      .addOff(MultimodalInputManager
        .subscribeCombinationKey([MultiKeyCode.CTRL_LEFT, MultiKeyCode.ALT_LEFT, MultiKeyCode.NUMPAD_DOT],
          true, (data) => {
            log.showInfo(TAG, `on CombinationKeyEvent: data: ${JSON.stringify(data)}`);
            ctrlAltDelPanelModel?.ctlAltDelCallBack();
          }))
      .addOff(MultimodalInputManager
        .subscribeCombinationKey([MultiKeyCode.CTRL_LEFT, MultiKeyCode.ALT_RIGHT, MultiKeyCode.NUMPAD_DOT],
          true, (data) => {
            log.showInfo(TAG, `on CombinationKeyEvent: data: ${JSON.stringify(data)}`);
            ctrlAltDelPanelModel?.ctlAltDelCallBack();
          }))
      .addOff(MultimodalInputManager
        .subscribeCombinationKey([MultiKeyCode.CTRL_RIGHT, MultiKeyCode.ALT_RIGHT, MultiKeyCode.NUMPAD_DOT],
          true, (data) => {
            log.showInfo(TAG, `on CombinationKeyEvent: data: ${JSON.stringify(data)}`);
            ctrlAltDelPanelModel?.ctlAltDelCallBack();
          }))
      .addOff(MultimodalInputManager
        .subscribeCombinationKey([MultiKeyCode.CTRL_RIGHT, MultiKeyCode.ALT_LEFT, MultiKeyCode.NUMPAD_DOT],
          true, (data) => {
            log.showInfo(TAG, `on CombinationKeyEvent: data: ${JSON.stringify(data)}`);
            ctrlAltDelPanelModel?.ctlAltDelCallBack();
          }));
    // 锁屏监听
    this.screenLockObserver = {
      notify: (): void => {
        log.showInfo(TAG, 'onLockScreen');
        ctrlAltDelPanelModel?.onLockScreen();
      }
    };
    screenLockMediator.addObserver(this.screenLockObserver);
  }

  private registerTransparentDetection(): void {
    const session = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId);
    session?.registerContextTransparentCallback(() => {
      log.showError('window is transparency!!');
    })
  }

  aboutToDisappear(): void {
    log.showInfo(TAG, 'aboutToDisappear');
    this.eventMgr.offAll();
    this.viewController.unRegisterCallback(this.viewCallback);
    viewMgrPolicy.unregisterViewController(ViewType.CTRL_ALT_DEL_PANEL);
    if (this.screenLockObserver !== null) {
      screenLockMediator.deleteObserver(this.screenLockObserver);
    }
    this.layoutViewModel.unregisterFoldStateListener(this);
    SCBScreenSessionManager.getInstance().unRegisterScreenPropertyChangeCallbacks(this.screenPropertyChangeCallBack, 
    this.screenProp.screenId);
  }
  
  build() {
    if (this.viewController.isShowing()) {
      Stack({ alignContent: Alignment.TopStart }) {
        Stack() {
        }
        .size({ width: '100%', height: '100%' })
        .backgroundColor(SCBConstants.CTRL_ALT_DELETE_PANEL_BG_BLUR_COLOR)
        .backgroundEffect({
          policy: 1,
          radius: SCBConstants.CTRL_ALT_DELETE_PANEL_BG_BLUR_RADIUS,
          saturation: SCBConstants.CTRL_ALT_DELETE_PANEL_SATURATION,
          brightness: 1,
        })

        WithTheme({ colorMode: ThemeColorMode.DARK }) {
          Column() {
            Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              Column() {
                ForEach(ctrlAltDelPanelModel.functionList.slice(0, ctrlAltDelPanelModel.functionList.length - 1),
                  (item: FunctionListInfo) => {
                  FunctionItemView({
                    functionItem: item,
                    itemListSize: this.functionListSize,
                  })
                })
              }
            }
            .width('100%')
            .margin({ top: this.layoutViewData.functionMarginTop })

            Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              CancelView()
            }
            .height(Constants.CANCLE_VIEW_HEIGHT)
            .margin({ top: this.layoutViewData.cancelViewMarginTop })
          }
          .margin({
            top: this.topBottomPadding,
            bottom: this.topBottomPadding,
          })
          .width('100%')
          .height('100%')
        }
      }
      .width('100%')
      .height('100%')
    }
  }
}
