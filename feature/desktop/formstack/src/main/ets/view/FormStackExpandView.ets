/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import { LengthMetrics } from '@kit.ArkUI';
import { lockLayoutManager, StyleConstants } from '@ohos/launchercommon';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { launcherStatusUtil, ScenePanelState } from '@ohos/windowscene';
import { FormStackExpandItem } from '../viewmodel/FormStackExpandItem';
import { FormStackExpandViewData } from '../viewmodel/FormStackExpandViewData';
import { FormStackExpandEvent } from '../viewmodel/FormStackExpandEvent';
import { FormStackExpandItemView } from './FormStackExpandItemView';
import { FormStackExpandConfig } from '../common/FormStackExpandConfig';
import { FormStackConstants } from '../common/FormStackConstants';
import { ExposureManager } from '@ohos/launchercommon/src/main/ets/manager/ExposureManager';

const TAG: string = 'FormStackExpandView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

@Component
export struct FormStackExpandView {
  @Prop @Watch('onDesktopStatusChange') isOuterDesktop: boolean = false;
  private mEvent: FormStackExpandEvent = new FormStackExpandEvent();

  @State mItemInfoList: FormStackExpandItem[] = [];
  @Consume('openFormStackFlag') mOpenFormStackFlag: boolean;
  @State @Watch('onChangeFormStackEditViewData') mViewData: FormStackExpandViewData = new FormStackExpandViewData();
  @StorageLink('isPortrait') @Watch('onPortraitStatusChange') mIsPortrait: boolean = true;
  @StorageProp('lockReceived') @Watch('onLockReceived') mLockReceived: number = 0;
  @StorageLink('formStackEditShow') @Watch('onFormStackExpandViewChange') mIsFormStackExpand: boolean = false;
  @StorageLink('scenePanelState') @Watch('onScenePanelStateChange') scenePanelState: ScenePanelState =
    ScenePanelState.HOME;
  @StorageLink('currColorMode') @Watch('onColorModeChange') currColorMode: number =
    GlobalContext.getContext().config.colorMode as number;
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  private onColorModeChange(): void {
    // 深浅模式切换时收起堆叠
    log.showInfo(`formstack expand view onColorModeChange, currDarkMode is: ${this.currColorMode}`);
    this.closeFormStackExpandView(false, false);
  }

  private onScenePanelStateChange(): void {
    // 桌面处于非首页状态时收起堆叠
    log.showInfo(`formstack expand onScenePanelStateChange: ${this.scenePanelState}`);
    if (this.scenePanelState !== ScenePanelState.HOME && this.scenePanelState !== ScenePanelState.RECENT) {
      this.closeFormStackExpandView(false, false);
    }
  }

  private onChangeFormStackEditViewData(): void {
    let stackDesktopState = AppStorage.get<boolean>('stackDesktopState');
    let desktopChanged = stackDesktopState !== launcherStatusUtil.getShowOutLauncherStatus();
    if (this.mOpenFormStackFlag &&
      (CheckEmptyUtils.isEmptyArr(this.mViewData.mItemInfoList) || !this.mViewData.mVisible)) {
      log.showInfo(`ViewModel change, set openFormStackFlag:false, lst len:${this.mViewData.mItemInfoList?.length}.`);
      this.mOpenFormStackFlag = false;
      this.mIsFormStackExpand = false;
    }
    if (desktopChanged) {
      this.mEvent.onBlankAreaClick();
    }
  }

  private onDesktopStatusChange(): void {
    this.mEvent.setDesktopStatus(this.isOuterDesktop)
  }

  private onFormStackExpandViewChange() {
    log.showInfo(`receive close form stack expand view msg, isFormStackExpand: ${this.mIsFormStackExpand}.`);
    if (!this.mIsFormStackExpand) {
      ExposureManager.getInstance().handleStackExposureTimeEnd();
      this.closeFormStackExpandView();
    } else {
      if (lockLayoutManager.isLockLayout()) {
        lockLayoutManager.toastLockedLayout();
      }
    }
  }

  private onPortraitStatusChange(): void {
    log.showInfo(`receive portrait status change msg, mIsPortrait: ${this.mIsPortrait}.`);
    FormStackExpandConfig.getInstance().initDisplayInfo();
    // 屏幕旋转时触发堆叠直接收起
    this.closeFormStackExpandView(false, false);
  }

  private onLockReceived() {
    log.showInfo(`receive msg, lockReceived: ${this.mLockReceived}.`);
    this.closeFormStackExpandView(true);
  }

  private closeFormStackExpandView(isCloseByLockScreen: boolean = false, isNeedAnimate: boolean = true): void {
    if (this.mOpenFormStackFlag) {
      this.mEvent.closeFormStackExpandView(isCloseByLockScreen, '', isNeedAnimate);
    }
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear.');
    this.mEvent.setDesktopStatus(this.isOuterDesktop);
    this.mViewData.mItemInfoList = this.mItemInfoList;
    let ret: boolean = this.mEvent.initData(this.mViewData, {
      onOpenFormStack: () => {
        this.mOpenFormStackFlag = true;
        this.mIsFormStackExpand = true;
      },
    });

    if (!ret) {
      log.showError('init event failed!');
      this.mEvent.resetData();
    }
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear.');
    this.mOpenFormStackFlag = false;
    this.mIsFormStackExpand = false;
    this.mEvent.resetData();
  }

  build() {
    if (this.mOpenFormStackFlag && this.mViewData.mVisible) {
      Stack({ alignContent: Alignment.Top }) {
        Column() {
          Stack() {
            this.stackHotArea()
            ForEach(this.mItemInfoList, (item: FormStackExpandItem) => {
              FormStackExpandItemView({
                mItemInfo: item,
                isOuterDesktop: this.isOuterDesktop,
                mSuperEventInterface: this.mEvent.mEventInterface,
                mUseEffectComIds: this.mEvent.getUseEffectComIds(),
              })
            }, (item: FormStackExpandItem) => item.idStr)
          }
          .width(StyleConstants.PERCENTAGE_100)
          .height(StyleConstants.PERCENTAGE_100)
          .align(Alignment.TopStart)
        }
        .accessibilityLevel('no')
        .width(StyleConstants.PERCENTAGE_100)
        .height(StyleConstants.PERCENTAGE_100)
        .backgroundBlurStyle(this.mViewData.mBlurStyle, {
          scale: this.mViewData.mBlurScale,
          policy: 1
        }, { disableSystemAdaptation: true })
        .onClick((event: ClickEvent) => {
          this.mEvent.onBlankAreaClick();
        })
        this.dropSnapshot();
      }
    }
  }

  @Builder
  stackHotArea() {
    Stack()
      .width(this.mViewData.mStackHotAreaWidth)
      .height(this.mViewData.mStackHotAreaHeight)
      .margin({
        start: LengthMetrics.vp(this.mViewData.mStackHotAreaMarinLeft),
        top: LengthMetrics.vp(this.mViewData.mStackHotAreaMarginTop),
      })
      .visibility(this.mViewData.mHotAreaVisible ? Visibility.Visible : Visibility.None)
      // 热区内的Drag Move事件拦截
      .onDragMove((event) => {
        this.mEvent.onDragMove(event);
      })
      .onDragLeave(() => {
        this.mEvent.onDragLeaveStack();
      })
      .onDrop((event) => {
        this.mEvent.onDragDropStack(event);
      })
  }

  @Builder
  dropSnapshot() {
    if (this.mViewData.mIsDropItem && this.mViewData.mDragSnapshot) {
      Image(this.mViewData.mDragSnapshot)
        .id(`${FormStackConstants.EDIT_DROP_IMAGE_ID}`)
        .draggable(false)
        .syncLoad(true)
        .width(FormStackExpandConfig.getInstance().mFormWidth)
        .height(FormStackExpandConfig.getInstance().mFormHeight)
        .borderRadius(FormStackExpandConfig.getInstance().mFormRadius)
        .scale({ x: this.mViewData.mDropScaleX, y: this.mViewData.mDropScaleY })
        .rotate({
          x: FormStackConstants.FORM_STACK_OPEN_ROTATE_POINT_X,
          centerY: FormStackConstants.FORM_STACK_OPEN_ROTATE_POINT_CENTER_Y,
          angle: this.mViewData.mDropAngle
        })
        .translate({ x: this.mViewData.mDropX, y: this.mViewData.mDropY })
    }
  }
}