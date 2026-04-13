/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
import { LogHelper, LogDomain } from '@ohos/basicutils';

const TAG = 'HoverAnimationUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * phone/pad的桌面元素鼠标hover动画工具类
 */
export default class HoverAnimationUtil {
  /**
   * 默认scale
   */
  private static readonly DEFAULT_ITEM_SCALE = 1;

  /**
   * hover大元素（卡片，大文件夹，多任务卡片等）时的放大倍数
   */
  private static readonly BIG_ITEM_HOVER_SCALE = 1.02;

  /**
   * hover小元素（1*1的图标、文件夹等）时的放大倍数
   */
  private static readonly SMALL_ITEM_HOVER_SCALE = 1.05;

  /**
   * hover动画执行时间
   */
  private static readonly ANIMATION_DURATION_TIME = 100;

  /**
   * hover动画曲线
   */
  private static readonly ANIMATION_CURVE = Curve.Friction;

  /**
   * hover动画效果
   *
   * @param isHover 是否在hover中
   * @param isSmallItem 是否是小元素（1*1）
   * @param callback 返回的scale大小赋值回调
   */
  public static hoverEffect(isHover: boolean, isSmallItem: boolean, callback: (hoverScale: number) => void): void {
    log.showInfo(`item isHover: ${isHover}, isSmallItem: ${isSmallItem}`);
    if (!callback) {
      log.showError('callback is undefined, can not execute hover animation');
      return;
    }
    animateTo({
      duration: HoverAnimationUtil.ANIMATION_DURATION_TIME,
      curve: HoverAnimationUtil.ANIMATION_CURVE
    }, () => {
      let hoverScale: number = HoverAnimationUtil.DEFAULT_ITEM_SCALE;
      if (isHover) {
        hoverScale = isSmallItem ? HoverAnimationUtil.SMALL_ITEM_HOVER_SCALE : HoverAnimationUtil.BIG_ITEM_HOVER_SCALE;
      }
      callback(hoverScale);
    })
  }
}