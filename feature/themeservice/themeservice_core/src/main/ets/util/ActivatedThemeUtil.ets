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
import { FileUtil, StringUtils, TsLog } from '@ohos/themeservicebase/Index';
import { commonEventManager } from '@kit.BasicServicesKit';

const TAG: string = `ActivatedThemeUtil`;

/**
 * A/B目录正在使用主题工具类
 */
export class ActivatedThemeUtil {
  // 主题画廊数据变更事件
  public static EVENT_THEME_APPLY: string = 'ts.event.theme.change';

  public static ACTIVATED_TMP_EID: string = 'eid_activated_tmp';

  public static readonly APP: string = 'app';

  public static readonly SYSTEM: string = 'system';

  private static readonly ACTIVATED_PATH_A = '/data/themes/a/';

  private static readonly ACTIVATED_PATH_B = '/data/themes/b/';

  private static readonly ACTIVATED_FLAG = 'app/flag';

  /**
   * 获取当前的AB目录
   */
  public static getActivatedThemePath(): string {
    if (FileUtil.isFileExists(ActivatedThemeUtil.ACTIVATED_PATH_A + ActivatedThemeUtil.ACTIVATED_FLAG)) {
      return ActivatedThemeUtil.ACTIVATED_PATH_A;
    } else if (FileUtil.isFileExists(ActivatedThemeUtil.ACTIVATED_PATH_B + ActivatedThemeUtil.ACTIVATED_FLAG)) {
      return ActivatedThemeUtil.ACTIVATED_PATH_B;
    } else {
      TsLog.warning(TAG, `Not found activated theme path`);
      return ActivatedThemeUtil.ACTIVATED_PATH_A;
    }
  }

  /**
   * 判断目标路径是否是主题应用目录 a/b目录
   * @param path 目标路径
   * @returns 是否是主题应用目录
   */
  public static isActivatedPath(path: string): boolean {
    if (StringUtils.isEmpty(path)) {
      return false;
    }
    if (path.startsWith(ActivatedThemeUtil.ACTIVATED_PATH_A) || path.startsWith(ActivatedThemeUtil.ACTIVATED_PATH_B)) {
      return true;
    }
    return false;
  }

  /**
   * 获取主题应用目录 a目录
   * @returns a目录
   */
  public static getActivatedPathA() {
    return ActivatedThemeUtil.ACTIVATED_PATH_A;
  }

  /**
   * 获取主题应用目录 b目录
   * @returns b目录
   */
  public static getActivatedPathB() {
    return ActivatedThemeUtil.ACTIVATED_PATH_B;
  }

  /**
   * 获取当前使能资源的路径
   * @param resType 资源类型
   * @returns 当前使能资源的路径
   */
  public static getActivateResPath(resType: string) {
    const activatePath: string = ActivatedThemeUtil.getActivatedThemePath();
    let activateResPath: string;
    if (resType === 'skin' && FileUtil.isFileExists(`${activatePath}${resType}`)) {
      activateResPath = `${activatePath}${resType}`;
    } else {
      activateResPath = `${activatePath}${ActivatedThemeUtil.APP}/${resType}`;
    }
    if (!FileUtil.isFileExists(activateResPath)) {
      activateResPath = `${activatePath}${ActivatedThemeUtil.SYSTEM}/${resType}`;
    }
    return activateResPath;
  }

  public static notifyApplyTheme(): void {
    const option: commonEventManager.CommonEventPublishData = {
      subscriberPermissions: ['ohos.permission.ACTIVATE_THEME_PACKAGE'],
      isOrdered: false,
      isSticky: false
    }
    try {
      TsLog.info(TAG, 'notifyApplyTheme start');
      commonEventManager.publish(ActivatedThemeUtil.EVENT_THEME_APPLY, option, (error) => {
        if (error) {
          TsLog.error(TAG, 'notifyApplyTheme error', error);
        } else {
          TsLog.info(TAG, 'notifyApplyTheme success');
        }
      });
    } catch (error) {
      TsLog.error(TAG, 'publish notifyApplyTheme error', error);
    }
  }
}

