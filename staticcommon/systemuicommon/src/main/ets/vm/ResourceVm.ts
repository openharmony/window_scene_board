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

import { ResUtils } from '@ohos/windowscene';
// import { LogDomain, LogHelper, MemoryUtils } from '@ohos/basicutils';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ConfigurationEvent, GlobalContext } from '@ohos/frameworkwrapper';
import { systemParameterEnhance } from '@kit.BasicServicesKit';
import { InnerEventUtil } from '../utils/InnerEventUtil';
import { i18n } from '@kit.LocalizationKit';
import { Singleton } from '../utils/Singleton';
import { ThreadSync } from '../messageChannel/ThreadSync';
import intl from '@ohos.intl';

const TAG = 'ResourceVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 资源相关的ViewModel
 */
@ThreadSync.VmDecorator
@ObservedV2
export class ResourceVm {
  @Singleton.decorate()
  public static get instance(): ResourceVm { return new ResourceVm(); }

  public static readonly DEFAULT_FONT_SCALE = 1;
  /**
   * 默认使用的最大缩放倍数
   */
  public static readonly DEFAULT_MAX_SCALE: number = 2;
  /**
   * 胶囊最大缩放倍数
   */
  public static readonly CAPSULE_MAX_SCALE: number = 1.15;

  /**
   * 当前语言
   */
  @Trace public language: string = '';
  /**
   * 是否为RTL语言
   */
  @Trace public isRTL: boolean = false;
  /**
   * 系统字体扩大倍数
   */
  @Trace public fontScale: number = ResourceVm.DEFAULT_FONT_SCALE;
  /**
   * 系统字体扩大倍数限制到DEFAULT_MAX_SCALE
   */
  @Trace public limitFontScale: number = ResourceVm.DEFAULT_FONT_SCALE;

  /**
   * 初始化
   */
  public init(): void {
    try {
      this.initLanguage();
      this.initFontSize();
      InnerEventUtil.on(ConfigurationEvent, this.onConfigurationEvent.bind(this));
    } catch (e) {
      log.error('Init error:', e);
    }
  }

  /**
   * 获取胶囊字体放大倍数
   * @param fontSize 原始字体大小
   */
  public getCapsuleSize(fontSize: Resource | number): Length {
    return this.getFontSize(fontSize, ResourceVm.CAPSULE_MAX_SCALE);
  }

  /**
   * 获取默认场景的字体缩放后的大小
   * @param fontSize 原始字体大小
   * @param maxScale 最大缩放倍数
   * @returns 缩放后的字体大小，单位vp
   */
  public getFontSize(fontSize: Resource | number, maxScale?: number): Length {
    const fontScale = this.getFontScale(maxScale);
    if (typeof fontSize === 'number') {
      return fontSize * fontScale + 'vp';
    }
    return this.getNumber(fontSize) * fontScale + 'vp';
  }

  /**
   * 获取字体放大倍数
   */
  public getFontScale(maxScale: number = ResourceVm.DEFAULT_MAX_SCALE): number {
    return Math.min(this.fontScale, maxScale);
  }

  /**
   * 获取实况卡片的字体缩放后的大小，Verde外屏不响应大字体
   * @param fontSize 原始字体大小
   * @param maxScale 最大缩放倍数
   * @returns 缩放后的字体大小，单位vp
   */
  public getLiveFontSize(fontSize: Resource | number, maxScale?: number): Length {
    const fontScale = this.getLiveFontScale(maxScale);
    if (typeof fontSize === 'number') {
      return fontSize * fontScale + 'vp';
    }
    return this.getNumber(fontSize) * fontScale + 'vp';
  }

  /**
   * 获取字体放大倍数
   */
  public getLiveFontScale(maxScale: number = ResourceVm.DEFAULT_MAX_SCALE): number {
    return Math.min(this.fontScale, maxScale);
  }

  public getLiveFontScaleHeightDiff(fontFixedAreaHeight: number): number {
    const fontScale = this.getLiveFontScale();
    const increase = fontScale - 1 < 0 ? 0 : fontScale - 1;
    return fontFixedAreaHeight * increase;
  }

  /**
   * 读取指定资源的字符串
   * @param res 资源对象或资源字符串
   */
  public getString(res: Resource | string, ...params: Array<number | string>): string {
    if (typeof res === 'string') {
      try {
        return GlobalContext.getContext()?.resourceManager?.getStringByNameSync(res, ...params);
      } catch (error) {
        log.showError(`getStringByNameSync failed, err:${error}`);
        return '';
      }
    }
    return GlobalContext.getContext()?.resourceManager?.getStringSync(res.id, ...params);
  }

  /**
   * 读取复数字符串
   * @param res 资源对象或资源字符串
   * @param num 数字
   */
  public getPluralString(res: Resource | string, num: number): string {
    if (typeof res === 'string') {
      return GlobalContext.getContext()?.resourceManager?.getPluralStringByNameSync(res, num);
    }
    return GlobalContext.getContext()?.resourceManager?.getPluralStringValueSync(res.id, num);
  }

  /**
   * 读取资源数字
   * @param res
   * @returns
   */
  public getResNumber(res: Resource | string): number {
    if (typeof res === 'string') {
      return GlobalContext.getContext()?.resourceManager?.getNumberByName(res);
    }
    return GlobalContext.getContext()?.resourceManager?.getNumber(res.id);
  }

  /**
   * 读取资源数字, 不受设置界面显示大小缩放影响
   * @param res
   * @returns
   */
  public getNumber(res: Resource): number {
    return ResUtils.getNumber(res);
  }

  public getNumberVp(res: Resource): string {
    return this.getNumber(res) + 'vp';
  }

  /**
   * 是否为某个语言
   * @param language
   * @returns
   */
  public isLanguage(language: string): boolean {
    return this.language === language;
  }

  private initLanguage(language?: string): void {
    this.language = language || i18n.System.getSystemLanguage();
    this.isRTL = i18n.isRTL(this.language);
  }

  private initFontSize(): void {
    const scaleSize = systemParameterEnhance.getSync('persist.sys.font_scale_for_user0', '1');
    log.showInfo(`Init fontSizeScale, ccm value:${scaleSize}`);
    if (!Number.isNaN(Number(scaleSize))) {
      this.fontScale = Number(scaleSize);
      this.limitFontScale = Math.min(this.fontScale, ResourceVm.DEFAULT_MAX_SCALE);
    }
  }

  private onConfigurationEvent(event: ConfigurationEvent): void {
    log.showInfo(`Configuation change, language: ${event.config?.language}, fontScale: ${event.config?.fontSizeScale}`);
    this.fontScale = event.config?.fontSizeScale ?? ResourceVm.DEFAULT_FONT_SCALE;
    this.limitFontScale = Math.min(this.fontScale, ResourceVm.DEFAULT_MAX_SCALE);
    if (event.config?.language) {
      this.initLanguage(event.config.language);
    }
  };

  public getFontScaleHeightDiff(fontFixedAreaHeight: number): number {
    const fontScale = this.getFontScale();
    const increase = fontScale - 1 < 0 ? 0 : fontScale - 1;
    return fontFixedAreaHeight * increase;
  }

  /**
   * 获取x方向的值, 镜像布局x方向取相反值
   * @param value
   * @returns
   */
  public getXDirectionValue(value: number): number {
    return value && this.isRTL ? -value : value;
  }

  public formatNumber(value: number): string {
    const formatter = new intl.NumberFormat();
    let result: string = formatter.format(value);
    // MemoryUtils.removeNapiWrap(formatter, false);
    return result;
  }

  public isTextRTL(text: string): boolean {
    const str = text.replaceAll(/[\d\s\.\+-:]/g, '');
    if (!str) {
      return this.isRTL;
    }
    return i18n.Unicode.isRTL(str);
  }
}