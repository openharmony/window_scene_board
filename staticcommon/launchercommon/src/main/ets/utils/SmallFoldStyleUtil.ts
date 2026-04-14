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

import { FileUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper, GlobalContext } from '@ohos/frameworkwrapper';
import { launcherStatusUtil } from '@ohos/windowscene';
import { ResUtils } from '@ohos/windowscene';
import type ctx from '@ohos.app.ability.common';

const TAG = 'SmallFoldStyleUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

/**
 * 小折叠手机工具类
 */
export class SmallFoldStyleUtil {
  // 小字体至大字体三挡 每个阶级 增大倍率
  public static readonly FONT_SIZE_MAGNIFICATION: number = 0.15;

  // 小字体: 0.85倍
  public static readonly SMALL_FONT_SIZE_SCALE: number = 0.85;

  // 默认: 1倍
  public static readonly NORMAL_FONT_SIZE_SCALE: number = 1;

  // 大字体1档: 1.15倍
  public static readonly LEVEL_BIG_1_FONT_SIZE_SCALE: number = 1.15;

  // 大字体2档: 1.3倍
  public static readonly LEVEL_BIG_2_FONT_SIZE_SCALE: number = 1.3;

  // 大字体3档: 1.45倍
  public static readonly LEVEL_BIG_3_FONT_SIZE_SCALE: number = 1.45;

  // 特大1档：1.75倍
  public static readonly BIG_FONT_SIZE_SCALE: number = 1.75;

  // 特大2档：2倍
  public static readonly BIG_FONT_SIZE_SCALE_2X: number = 2;

  // 特大3档：3.2倍
  public static readonly BIG_FONT_SIZE_SCALE_3X: number = 3.2;

  // 编辑模式底部按钮区前后最小间距
  public static readonly EDIT_MODE_BUTTON_DOCK_CONTENT_OFFSET: number = 16;

  // 多任务分类文件路径
  private static readonly MULTITASKING_FILTER_PATH: string = '/sys_prod/etc/launcher/square_screen_multitasking_filter.json';

  private static readonly FILTER: string = 'filter';

  private static readonly BUNDLE_NAME: string = 'bundleName';

  private static readonly ABILITIES: string = 'abilities';

  private static multitaskingFilterMap: Map<string, string[]>;

  /**
   * 获取字体、行高使用大小（vp）
   *
   * @param font 当前字体,行高大小
   * @param fontSizeScale 最大字体,行高大小倍率
   * @returns 限制后的字体,行高大小
   */
  public static getScaleSize(fontSize: Resource | number, fontSizeScale: number): string {
    if (typeof fontSize === 'number') {
      return fontSize * SmallFoldStyleUtil.getFontScale(fontSizeScale) + 'vp';
    }
    return ResUtils.getNumber(fontSize) * SmallFoldStyleUtil.getFontScale(fontSizeScale) + 'vp';
  }

  /**
   * 获取字体放大倍数
   *
   * @param maxFontSizeScale 最大放大倍率
   * @returns 放大倍率
   */
  public static getFontScale(maxFontSizeScale: number): number {
    return Math.min(maxFontSizeScale, SmallFoldStyleUtil.getFontSizeScale());
  }

  /**
   * 获取当前系统字体放大倍率
   *
   * @returns 当前系统字体放大倍率
   */
  public static getFontSizeScale(): number {
    let fontSizeScale = (GlobalContext.getInstance()
      .getObject('desktopContext') as ctx.ServiceExtensionContext).config.fontSizeScale || 1;
    return fontSizeScale;
  }

  /**
   * 获得多任务过滤名单
   *
   * @returns key: bundleName  value: abilities
   */
  public static getMultitaskingFilterMap(): Map<string, string[]> {
    if (SmallFoldStyleUtil.multitaskingFilterMap === undefined) {
      SmallFoldStyleUtil.multitaskingFilterMap = new Map();
    }
    return SmallFoldStyleUtil.multitaskingFilterMap;
  }

  /**
   * 解析多任务过滤名单
   */
  private static parseMultitaskingFilterFile(): void {
    let filterObj: object = FileUtils.readJsonFile(SmallFoldStyleUtil.MULTITASKING_FILTER_PATH);
    if (filterObj === null) {
      log.showInfo('parseMultitaskingFilterFile filterObj is null');
      return;
    }
    let filter: object[] = filterObj?.[SmallFoldStyleUtil.FILTER];
    if (filter === undefined) {
      log.showInfo('parseMultitaskingFilterFile filter is null');
      return;
    }
    for (let i = 0; i < filter.length; i++) {
      let bundleName: string = filter?.[i]?.[SmallFoldStyleUtil.BUNDLE_NAME];
      if (bundleName === undefined) {
        log.showInfo('parseMultitaskingFilterFile bundleName is undefined continue');
        continue;
      }
      let abilities: string[] = filter?.[i]?.[SmallFoldStyleUtil.ABILITIES];
      SmallFoldStyleUtil.multitaskingFilterMap.set(bundleName, abilities);
    }
  }
}