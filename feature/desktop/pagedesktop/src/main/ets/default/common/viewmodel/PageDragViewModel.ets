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

import { LogDomain, LogHelper, SingleBase, SingleContext, singleManager } from '@ohos/basicutils';
import { folderLayoutUtil, GridLayoutItemInfo } from '@ohos/launchercommon';
import {
  ForceType,
  GravityAnimationConfig,
  GravityAnimationManager
} from '@ohos/componentanimator/Index';

const TAG = 'PageDragViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * SwiperPage跟拖拽（包含onTouch）相关的ViewModel类
 */
export class PageDragViewModel extends SingleBase {
  public static singleName: string = 'PageDragViewModel';
  private gravityAnimTimeoutId?: number;
  private isOuterDesktop: boolean = false;

  /**
   * 获取单例
   *
   * @return SwiperPageViewModel
   */
  static getInstance(ctx?: SingleContext): PageDragViewModel {
    return singleManager.get<PageDragViewModel>(PageDragViewModel, ctx);
  }

  /**
   * 初始化设备信息
   *
   * @param isOuterDesktop 是否外屏
   */
  public initDeviceInfo(isOuterDesktop: boolean): void {
    this.isOuterDesktop = isOuterDesktop;
  }

  /**
   * 合并文件夹/落入文件夹场景触发引力动效
   *
   * @param indexInSwiper
   * @param swiperKey 触发引力动效的目标页
   * @param endLayoutInfo 目标元素/目标文件夹
   * @returns boolean
   */
  public triggerGravityAnimationWithFolder(
    indexInSwiper: number,
    swiperKey: number,
    endLayoutInfo?: GridLayoutItemInfo): boolean {
    if (!endLayoutInfo) {
      return false;
    }
    let size = endLayoutInfo.area as number[];
    let folderCenterPos = folderLayoutUtil.getCurrentFolderCenterPosition(endLayoutInfo);
    this.gravityAnimTimeoutId = setTimeout(() => {
      this.gravityAnimTimeoutId = undefined;
      if (indexInSwiper !== undefined) {
        log.showInfo(`trigger gravity animation with item drop on folder`);
        GravityAnimationManager.getInstance()
          .run(swiperKey, folderCenterPos[0], folderCenterPos[1], ForceType.GRAVITATION, size);
      }
    }, GravityAnimationConfig.getDelayOnDrop());
    return true;
  }
}