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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ViewCallback, GlobalContext } from '@ohos/frameworkwrapper';
import {
  CardItemInfo,
  DeviceState,
  FormCenterViewManager,
} from '@ohos/launchercommon';
import {
  FormCenterViewController,
  FormCenterViewParam,
} from '@ohos/launchercommon/src/main/ets/manager/FormCenterViewManager';
import { NavDestinationViewData } from '../../default/viewmodel/FormCenterObservedData';
import SwiperLayout from './layout/SwiperLayout';
import { SwiperLayoutViewData } from '../viewmodel/data/SwiperLayoutViewData';
import { FormManagerEventInterface } from '../interfaces/FormManagerEventInterface';
import { BindSheetStateData } from '../viewmodel/data/BindSheetStateData';
import { FormManagerEventFactory } from '../viewmodel/factory/FormManagerEventFactory';
import { FormManagerStyle } from '../viewstyles/FormManagerStyle';
import { FormManagerStyleConfig } from '../viewstyles/manager/FormManagerStyleConfig';

const TAG = 'FormManagerView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

@Component
export struct FormManagerView {
  private style: FormManagerStyle = FormManagerStyleConfig.getInstance().getStyle();
  private mFormCenterViewManager: FormCenterViewManager = FormCenterViewManager.getInstance();
  private mViewStateChangeCallback?: ViewCallback;
  private mSwiperLayoutData: SwiperLayoutViewData = new SwiperLayoutViewData();
  private mEvent?: FormManagerEventInterface;
  private location: string = '';
  private isNegativeScreenOpen: boolean = false;
  private detentsDidChange: boolean = false;
  private closeFormEffect: boolean = false;
  private mViewController: FormCenterViewController = {
    showView: (param: FormCenterViewParam): void => {
      log.showWarn('show view');
      this.mSwiperLayoutData = new SwiperLayoutViewData();
      this.mEvent = FormManagerEventFactory.createFormManagerEvent({
        formCenterViewParam: param,
        mViewData: this.mViewData,
        bindSheetStateData: this.bindSheetStateData,
        swiperLayoutData: this.mSwiperLayoutData,
        mViewStateChangeCallback: this.mViewStateChangeCallback,
      });
      this.mEvent?.showView(param, () => {
        this.style = FormManagerStyleConfig.getInstance().getStyle();
        if (this.mFormCenterViewManager.getFormCenterBlurDisable()) {
          this.style.blurStyle = BlurStyle.NONE;
          this.style.backgroundColor = $r('sys.color.ohos_id_color_panel_bg');
        }
        log.showWarn('really show view');
        this.bindSheetStateData.isShow = true;
        this.mViewStateChangeCallback?.onShow?.(TAG);
      });
    },
    closeView: () => this.mEvent?.closeView(),
    hideView: () => this.mEvent?.hideView(),
    getViewState: () => this.mEvent?.getViewState() ?? false,
    backGestureHandler: () => this.mEvent?.backGestureHandler(),
  }
  @State mViewData: NavDestinationViewData = new NavDestinationViewData();
  @State bindSheetStateData: BindSheetStateData = new BindSheetStateData();
  @Provide mStartFormInfo: CardItemInfo = new CardItemInfo();
  @StorageProp('lockReceived') @Watch('closeFormManager') lockReceived: number = 0;
  @StorageProp('folderStatus') @Watch('closeFormManager') folderStatus: number = DeviceState.DEFAULT_STATE;
  @StorageLink('isPortrait') @Watch('closeFormManager') mIsPortrait: boolean = true;

  private closeFormManager(): void {
    this.mEvent?.closeView();
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    this.location = this.mViewStateChangeCallback ? 'others' : 'desktop';
    if (this.isNegativeScreenOpen) {
      this.location = 'SCBNegativeScreen';
    }
    this.mFormCenterViewManager.registerFormManagerViewController(this.location, this.mViewController);
  }

  aboutToDisAppear(): void {
    log.showInfo('aboutToDisAppear');
    this.mFormCenterViewManager.unRegisterFormManagerViewController(this.location);
  }

  @Builder
  formBindSheetBuilder() {
    Column() {
      this.titleAllBuilder()
      SwiperLayout({
        mViewData: this.mSwiperLayoutData,
        mBindSheetViewData: this.mViewData,
        mEvent: this.mEvent?.getSwiperLayoutEvent(),
        style: this.style.swiperLayoutStyle,
      })
    }
    .height('100%')
  }

  @Builder
  titleAllBuilder() {
    Row() {
      this.mEvent?.getTitleBuilder?.().buildTitle().builder({
        appInfo: this.mSwiperLayoutData.appInfo,
        formItem: this.mSwiperLayoutData.appFormList[this.mSwiperLayoutData.swipeTargetIndex],
        textUpdater: this.mEvent?.getFormNameUpdater?.()
      })
    }
    .padding(this.style.titleRowPadding)
    .width(this.style.titleRowWidth)
    .height(this.style.titleRowHeight)
  }

  build() {
    Stack()
      .id(`${TAG}_Stack`)
      .position({ x: 0, y: 0 })
      .bindSheet(this.bindSheetStateData.isShow, this.formBindSheetBuilder(), {
        width: this.mViewData.bindSheetWidth,
        height: this.mViewData.bindSheetHeight,
        showClose: this.style.showClose,
        dragBar: this.style.dragBar,
        blurStyle: this.style.blurStyle,
        backgroundColor: this.style.backgroundColor,
        detents: [this.bindSheetStateData.height, 0],
        mode: this.style.mode,
        preferType: this.style.getPreferType?.(),
        onAppear: () => {
          log.showWarn('bindSheet onAppear');
        },
        onWillDisappear: () => {
          this.detentsDidChange = false;
          this.closeFormEffect = false;
          this.mEvent?.onBindSheetWillDisAppear?.();
        },
        onDisappear: () => {
          this.mViewStateChangeCallback?.onHide?.(TAG);
          log.showWarn('bindSheet onDisappear');
        },
        onDetentsDidChange: (height: number) => {
          this.mEvent?.onDetentsDidChange?.(height);
          this.detentsDidChange = true;
        },
        onHeightDidChange: () => {
          if (!this.detentsDidChange && !this.closeFormEffect) {
            log.showInfo('interrupt form effect');
            GlobalContext.getContext()?.eventHub.emit('interruptFormEffect');
            this.closeFormEffect = true;
          }
          this.detentsDidChange = false;
        }
      })
  }
}