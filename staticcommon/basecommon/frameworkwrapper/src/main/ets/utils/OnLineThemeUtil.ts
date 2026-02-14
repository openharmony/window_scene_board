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

import { settings } from '@kit.BasicServicesKit';
import { SettingsKeyConstants } from '@ohos/commonconstants';
import { CheckEmptyUtils, LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { SettingsUtil } from '../TsIndex';

const TAG = 'OnLineThemeUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

class OnLineThemeUtil {
  private themeOrigin: string = '';
  private themeOnlineStyle: string = '';
  private isNewThemeId: boolean = false;
  private oldThemeId: string = '';
  private curThemeId: string = '';

  /**
   * 缓存主题安装来源信息
   * 与主题目录中description.json文件的origin字段对应：
   * preset：预置完整的主题包
   * presetFragment:需要跳转到主题app，完成整包下载后才能使用
   * online：在线主题
   *
   * @param themeOrigin 主题安装来源信息
   */
  public setThemeOrigin(themeOrigin: string): void {
    log.showInfo(`setThemeOrigin ${themeOrigin}`);
    SettingsUtil.setValueEx(settings.domainName.USER_PROPERTY,
      SettingsKeyConstants.IS_ONLINE_THEME, String(themeOrigin === 'online'));
    this.themeOrigin = themeOrigin;
  }

  /**
   * 缓存主题中图标风格配置
   * 与主题目录中manifest.json文件的onlineStyle字段对应：
   * enable: 为在线主题风格
   * disable: 非在线主题风格
   *
   * @param themeOnlineStyle 主题风格配置信息
   */
  public setThemeOnlineStyle(themeOnlineStyle: string): void {
    log.showInfo(`setThemeOnlineStyle ${themeOnlineStyle}`);
    this.themeOnlineStyle = themeOnlineStyle;
  }

  /**
   * 保存记录主题Id
   * 与主题目录中description.json文件的id字段对应
   * 不存在description.json时则与manifest.json文件中id字段对应
   *
   * @param themeId 主题id
   */
  public setThemeId(themeId: string): void {
    if (CheckEmptyUtils.checkStrIsEmpty(themeId)) {
      log.showWarn('invalid themeId');
      return;
    }
    let oldThemeId: string = SettingsUtil.getValueEx(settings.domainName.USER_PROPERTY,
      SettingsKeyConstants.THEME_ID, '');
    this.oldThemeId = oldThemeId;
    this.curThemeId = themeId;
    if (oldThemeId !== themeId) {
      log.showInfo(`setThemeId new: ${themeId}, old: ${oldThemeId}`);
      SettingsUtil.setValueEx(settings.domainName.USER_PROPERTY, SettingsKeyConstants.THEME_ID, String(themeId));
      if (!CheckEmptyUtils.checkStrIsEmpty(oldThemeId)) {
        this.isNewThemeId = true;
      }
      return;
    }
    log.showInfo(`setThemeId same: ${themeId}, old: ${oldThemeId}`);
    this.isNewThemeId = false;
  }

  /**
   * 校验当前是否为在线主题
   * 注：该识别方法依赖主题切换时通过AppStorage设置，在开机阶段可能不准确
   *
   * @returns true:在线主题 false:非在线主题
   */
  public isOnlineTheme(): boolean {
    if (CheckEmptyUtils.checkStrIsEmpty(this.themeOnlineStyle)) {
      return this.themeOrigin === 'online';
    }
    return this.themeOnlineStyle === 'enable';
  }

  public newThemeId(): boolean {
    return this.isNewThemeId;
  }
}

export const onLineThemeUtil: OnLineThemeUtil = SingletonHelper.getInstance(OnLineThemeUtil, TAG);