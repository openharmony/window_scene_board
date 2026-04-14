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
import { ActivateType, TrialContentType, TrialRollbackType} from '@ohos/themeservice_inner_api/Index';
import { TrialThemeInfo } from '../../remote/model/TrialThemeInfo';

/**
 * 主题试用服务
 */
export interface ThemeTrialService {
  /**
   * 判断主题是否是试用主题
   * @param {string} themeEditorId 主题编辑ID，主题画廊中主题记录
   * @returns {Promise<boolean>} true：是试用主题，false：不是试用主题
   */
  isTrialTheme(themeEditorId: string): Promise<boolean>;

  /**
   * 大桌面进程启动后，延时1分钟，检查是否存在试用到期（TS内部调用）
   */
  onInit(): Promise<void>;

  /**
   * 获取正在试用的主题/字体信息（主题App调用）
   * @returns {Promise<TrialCacheData>} 有正在试用返回试用主题信息，无试用返回空数据
   */
  getTrialTheme(): Promise<TrialThemeInfo>;

  /**
   * 激活试用主题/字体（主题App调用）
   * @param {string} path 试用主题包资源路径
   * @param {number} trialDuration 试用时长，单位ms
   * @param {TrialContentType} trialType 试用类型 theme：试用主题， font：试用字体
   * @param {ActivateType} activateType 使能类型 0：试用， 1：限免
   * @param {number} reminderDuration 限免提醒时长，单位ms
   * @returns {Promise<number>} 试用成功返回0，其他返回错误码
   */
  activateTrialTheme(path: string, trialDuration: number, trialType: TrialContentType, activateType: ActivateType,
    reminderDuration?: number): Promise<number>;

  /**
   * 试用中主题/字体升级成付费/会员主题/字体（主题App调用）
   * @param {string} id 正在试用的主题ID/字体ID
   * @param {string} path 主题包路径
   * @param {TrialContentType} trialType 试用类型 theme：试用主题， font：试用字体
   * @returns {Promise<number>} 升级成功返回0，其他返回错误码
   */
  promoteFreeTheme(id: string, path: string, trialType: TrialContentType): Promise<number>;

  /**
   * 回退原始主题/字体
   * 1、试用主题切试用字体、试用字体切试用主题、试用到期（主题App调用）
   * 2、试用到期兜底（TS内部调用）
   * @param {TrialRollbackType} trialRollbackType 需要回退的类型，prev：回退前一个主题，default：回退默认主题
   * @returns {Promise<number>} 回退成功返回0，其他返回错误码
   */
  rollbackTheme(trialRollbackType: TrialRollbackType): Promise<number>;

  /**
   * 停止试用主题/字体（TS内部调用）
   * 1、试用主题切普通主题
   * 2、试用字体切普通字体
   * @param {TrialContentType} trialType 试用类型 theme：试用主题， font：试用字体
   */
  stopTrialTheme(trialType: TrialContentType): Promise<void>;

  /**
   * 校准限制免费主题时间
   * @param themeId 限制免费主题id
   * @param trialContentType 试用主题内容类型
   * @param limitedDuration 校准后到期时间
   * @param reminderDuration 校准后提醒剩余时间
   * @returns Promise<number>;
   */
  correctLimitedFreeTheme(themeId: string, trialContentType: TrialContentType, limitedDuration: number,
    reminderDuration: number): Promise<number>;

  /**
   * 关闭所有定时器
   */
  stopTimer(): Promise<void>;

  /**
   * 重新开启定时器
   */
  restartTimer(): Promise<void>;
}