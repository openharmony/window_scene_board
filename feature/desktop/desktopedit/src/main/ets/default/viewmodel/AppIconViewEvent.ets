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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DropAnimationScene } from '@ohos/componentanimator';
import { DragDataType, DragExtraInfo } from '@ohos/componentdrag';
import { AppIconAnimate } from './AppIconAnimate';
import { AppIconItemData } from './OuterEditCenterObservedData';
import { image } from '@kit.ImageKit';
import {
  AppItemInfo,
  CommonConstants,
  DesktopUtils,
  EditModeUtils,
  GridLayoutItemInfo,
  GridLayoutUtil
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { dropAnimationManager } from '@ohos/componentanimator/Index';
import lazy { OuterIconCenterViewManager } from '@ohos/launchercommon/src/main/ets/manager/OuterIconCenterViewManager';

const TAG: string = 'AppIconViewEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 外屏应用管理
 */
export class AppIconViewEvent {
  private mAppIconAnimate: AppIconAnimate = new AppIconAnimate();

  /**
   * 初始化动效数据
   * @param animateData 数据
   */
  public initData(animateData: AppIconItemData): void {
    this.mAppIconAnimate.initData(animateData);
  }

  /**
   * 长按动效处理
   * @param index 页面
   */
  public longPressHandler(index: number): void {
    this.mAppIconAnimate.scaleAnimate(false);
  }

  /**
   * 拖拽开始
   * @param event 事件
   * @param appItem 应用信息
   * @param appSize 应用尺寸
   * @param pixelMap pixelMap
   *
   * @returns 拖拽对象信息
   */
  public onDragStart(event: DragEvent, appItem: AppItemInfo, appSize: number, pixelMap?: image.PixelMap): DragItemInfo {
    let dragItemInfo: DragItemInfo = {
      extraInfo: new DragExtraInfo(DragDataType.APP).setRadius(-1).toString(),
    };
    appItem.typeId = CommonConstants.TYPE_APP;

    // 由于卡片设置了marginTop值，落位点Y轴需设置偏差，这个值会随设备变化
    let itemKey: string = GridLayoutUtil.generateUniqueKey(appItem as Object as GridLayoutItemInfo);
    dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, itemKey)
    ?.setWidth(EditModeUtils.getDesktopScale() * appSize)
      .setHeight(EditModeUtils.getDesktopScale() * appSize);

    AppStorage.setOrCreate('isDrag', true);
    AppStorage.setOrCreate('dragItemType', CommonConstants.DRAG_FROM_APP_ICON);
    AppStorage.setOrCreate('dragItemInfo', appItem);
    return dragItemInfo;
  }

  /**
   * 拖拽结束
   */
  public onDragEnd() {
    AppStorage.setOrCreate<boolean>('isDrag', false);
    AppStorage.setOrCreate<Object>('dragItemInfo', {});
  }

  /**
   * 触发onTouch事件
   * @param event 事件
   */
  public onTouch(event: TouchEvent): void {
    if (event?.type === TouchType.Down) {
      this.mAppIconAnimate.scaleAnimate(true);
    }
    if (event?.type === TouchType.Up) {
      this.mAppIconAnimate.scaleAnimate(false);
    }
  }

  /**
   * 触发点击动效
   *
   * @param appName 应用名
   * @param callback 回调
   */
  public startItemClickAnim(appName: string, callback?: () => void): void {
    this.mAppIconAnimate.startOnClickAnim(appName, callback);
  }
}