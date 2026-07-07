/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
import { i18n } from '@kit.LocalizationKit';

/**
 * RTL语言工具类，用于判断当前是否是RTL语言
 */
export class NtfSettingRtlUtil {
  /**
   * 获取系统语言是否是RTL语言
   *
   * @returns 系统语言是否是RTL语言
   */
  public static getSystemRTL(): boolean {
    let systemLanguage: string = i18n.System.getSystemLanguage();
    let isRTL: boolean = i18n.isRTL(systemLanguage);
    return isRTL;
  }
}