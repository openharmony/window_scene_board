/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
import { GlobalContext, ResourceManager, ViewCallback } from '@ohos/frameworkwrapper'
import {
  EditModeConstants,
  editModeManager,
  EditModeUtils,
  GridLayoutItemInfo,
  GridLayoutUtil
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { EditModeStyleConfig } from '@ohos/launchercommon/src/main/ets/editmode/data/PageEditData';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import curves from '@ohos.curves';
import { ForceType } from '@ohos/componentanimator/Index';
import {
  GravityAnimationManager
} from '@ohos/componentanimator/src/main/ets/service/animator/gravity/manager/GravityAnimationManager';
import { SwiperLoadData } from '@ohos/swiperdata';
import EditModeStyleConstants from '../common/constants/EditModeStyleConstants';

const TAG = 'AppItemToDeskAnimationComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const ICON_SIZE = 52;

/**
 * 外屏应用页面管理
 */
@Component
export struct AppItemToDeskAnimationComponent {
  @State startAnimate: boolean = false;
  @State animateScale: number = 0;
  @State translateX: number = 0;
  @State translateY: number = 0;
  @State backgroundOpacity: number = 0;
  @State animateOpacity: number = 1;
  @State appItemWidth?: number = 0;
  @State appItemHeight?: number = 0;
  private mPosition: Position = { x: 0, y: 0 };
  private desktopContext: ServiceExtensionContext = GlobalContext.getContext();
  private mAppItem: GridLayoutItemInfo = new GridLayoutItemInfo();
  private editModeStyleConfig: EditModeStyleConfig = editModeManager.getEditModeStyleConfig();
  private mViewStateChangeCallback?: ViewCallback;
  private imageCacheKey: string = '';
  private timeOutId: number | undefined = undefined;

  aboutToAppear() {
    this.desktopContext.eventHub.on('createAppItemToDesktop', (appItem: GridLayoutItemInfo, dropPosition: number[],
      cacheKey?: string, dragItemType?: number) => {
      log.showInfo('event createAppItemToDesktop');
      this.mAppItem = appItem;
      log.showInfo(`add appItem bundleName: ${appItem.bundleName}`);
      // 添加开始时设置bundleName 目的是根据bundleName隐藏桌面上的AppItem
      AppStorage.setOrCreate(EditModeConstants.ADD_OUTER_APP_ITEM, appItem);
      this.onAppItemManageCreateAppItem(appItem, dropPosition, cacheKey, dragItemType);
    });
    this.desktopContext.eventHub.on('createAppItemToDesktopResult', (appItem: GridLayoutItemInfo) => {
      log.showInfo('event createAppItemToDesktopResult');
      this.doCreateAppItemAnimation(appItem);
    });
  }

  aboutToDisappear(): void {
    this.desktopContext?.eventHub.off('createAppItemToDesktop');
    this.desktopContext?.eventHub.off('createAppItemToDesktopResult');
  }

  private onAppItemManageCreateAppItem(appItem: GridLayoutItemInfo, dropPosition: number[]
    , cacheKey?: string, dragItemType?: number): void {
    if (!appItem || !dropPosition) {
      log.showWarn(`invalid app item: ${appItem} or dropPosition error : ${dropPosition}`);
      return;
    }
    this.imageCacheKey = cacheKey ? cacheKey : `${appItem.appName}${appItem.bundleName}${appItem.moduleName}`;
    log.showInfo(`imageCacheKey: ${this.imageCacheKey}`);
    this.appItemWidth = appItem.size;
    this.appItemHeight = appItem.size;
    this.mPosition.x = dropPosition[0];
    this.mPosition.y = dropPosition[1];
    // 初始位置调整,有dragItemType时表示拖拽
    if (dragItemType) {
      this.mPosition.x -= EditModeUtils.convertWithDesktopScale(this.appItemWidth) / EditModeStyleConstants.NUM_2;
      this.mPosition.y -= EditModeUtils.convertWithDesktopScale(this.appItemHeight) / EditModeStyleConstants.NUM_2;
    } else {
      this.mPosition.x += (EditModeStyleConstants.DEFAULT_ZOOM_ANIMATE_SCALE *
      EditModeUtils.convertWithDesktopScale(this.appItemWidth) -
      EditModeUtils.convertWithDesktopScale(this.appItemWidth)) / EditModeStyleConstants.NUM_2;
      this.mPosition.y += (EditModeStyleConstants.DEFAULT_ZOOM_ANIMATE_SCALE *
      EditModeUtils.convertWithDesktopScale(this.appItemHeight) -
      EditModeUtils.convertWithDesktopScale(this.appItemHeight)) / EditModeStyleConstants.NUM_2;
    }

    this.translateX = 0;
    this.translateY = 0;
    // 默认放大倍率,放大后长宽与APP管理页Item大小一致
    this.animateScale = EditModeStyleConstants.DEFAULT_ZOOM_ANIMATE_SCALE;
    this.showAnimateComponent();
  }

  // 显示本页面必须通过此接口控制,避免外部业务流程不闭环导致页面阻塞桌面事件
  private showAnimateComponent(): void {
    log.showInfo('showAnimateComponent');
    this.mViewStateChangeCallback?.onShow?.(TAG);
    this.startAnimate = true;
    this.timeOutId = setTimeout(() => {
      if (this.startAnimate) {
        log.showWarn('component close by self');
        this.mViewStateChangeCallback?.onHide?.(TAG);
        this.startAnimate = false;
        AppStorage.setOrCreate(EditModeConstants.ADD_OUTER_APP_ITEM, undefined);
      }
    }, EditModeStyleConstants.SHOW_ANIMATE_DELAY_TIME);
  }

  private doCreateAppItemAnimation(appItem: GridLayoutItemInfo) {
    let fallPosition: number[] =
      GridLayoutUtil.getIconCenterPosition(appItem.row, appItem.column, appItem?.area, appItem?.page);
    let iconPosition = ICON_SIZE * this.editModeStyleConfig.swiperEditScaleRate / EditModeStyleConstants.NUM_2;
    fallPosition[0] -= iconPosition;
    fallPosition[1] -= iconPosition;
    let translateTempX: number = fallPosition[0] - Number(this.mPosition.x);
    let translateTempY: number = fallPosition[1] - Number(this.mPosition.y);
    animateTo(
      {
        duration: EditModeStyleConstants.CREATE_APP_ITEM_ANIMATION_DURATION,
        curve: curves.cubicBezier(EditModeStyleConstants.CUBIC_BEZIER_X1, EditModeStyleConstants.CUBIC_BEZIER_Y1,
          EditModeStyleConstants.CUBIC_BEZIER_X2, EditModeStyleConstants.CUBIC_BEZIER_Y2),
        onFinish: () => {
          log.showInfo('first scale step end');
          animateTo(
            {
              curve: curves.springMotion(EditModeStyleConstants.SPRING_MOTION_RESPONSE,
                EditModeStyleConstants.SPRING_MOTION_DAMPING_FRACTION_ZOOM, 0),
              onFinish: () => {
                this.doClear();
              }
            }, () => {
            // 触发落位时同步触发引力动效
            this.triggerGravityAnimation(appItem, fallPosition);
            this.animateScale = EditModeStyleConstants.DEFAULT_ANIMATE_SCALE;
          })
        }
      }, () => {
      this.animateScale = EditModeStyleConstants.ZOOM_ANIMATE_SCALE;
    });

    animateTo({
      curve: curves.springMotion(EditModeStyleConstants.SPRING_MOTION_RESPONSE,
        EditModeStyleConstants.SPRING_MOTION_DAMPING_FRACTION_MOVE, 0),
      onFinish: () => {
        log.showInfo('addFormAnimation end');
      }
    }, () => {
      this.translateX = translateTempX;
      this.translateY = translateTempY;
    });
  }

  private doClear() {
    this.startAnimate = false;
    // 取消隐藏桌面上的AppItem
    AppStorage.setOrCreate(EditModeConstants.ADD_OUTER_APP_ITEM, undefined);
    if (this.timeOutId != undefined) {
      clearTimeout(this.timeOutId);
    }
    ResourceManager.getInstance().deleteAppResourceCache(this.imageCacheKey, 'appItemSnapshot');
  }

  private triggerGravityAnimation(appItem: GridLayoutItemInfo, position: number[]): void {
    const pageIndex = appItem.page as number;
    const size = appItem.area as number[];

    GravityAnimationManager.getInstance().runLater(EditModeStyleConstants.RUNLATER_DELAY_TIME,
      SwiperLoadData.getInstance().getSwiperKeyByIndex(pageIndex), position,
      ForceType.REPULSION, size);
  }

  @Styles
  normalStyle() {
    .position(this.mPosition)
    .translate({
      x: this.translateX,
      y: this.translateY
    })
    .scale({
      x: this.animateScale,
      y: this.animateScale
    })
    .size({
      width: EditModeUtils.convertWithDesktopScale(this.appItemWidth),
      height: EditModeUtils.convertWithDesktopScale(this.appItemHeight)
    })
    .clip(true)
  }

  build() {
    if (this.startAnimate) {
      Stack() {
        Column() {
        }
        .normalStyle()
        .backgroundColor($r('app.color.transparent_form_background_color'))
        .opacity(this.backgroundOpacity)

        Image(ResourceManager.getInstance().getCachedIconPixelMapByKey(this.imageCacheKey))
          .draggable(false)
          .objectFit(ImageFit.Fill)
          .normalStyle()
          .syncLoad(true)
          .opacity(this.animateOpacity)
          .autoResize(false)
          .interpolation(ImageInterpolation.Medium)
      }
      .zIndex(1)
      .height('100%')
      .width('100%')
    }
  }
}