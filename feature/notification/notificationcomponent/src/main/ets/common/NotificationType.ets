/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2025. All rights reserved.
 */
/**
 * 通知面板类型
 *
 * @since 2022-12-21
 */
export class NotificationType {
  /**
   * 通知类型，PC通知面板
   */
  public static readonly TYPE_PC = 1;

  /**
   * 通知类型，Phone下拉面板
   */
  public static readonly TYPE_PHONE_DROPDOWN = 2;

  /**
   * 通知类型，Phone锁屏面板
   */
  public static readonly TYPE_PHONE_KEYGUARD = 3;

  /**
   * 通知类型，PhoneAOD面板
   */
  public static readonly TYPE_PHONE_AOD = 4;

  /**
   * 通知类型，Phone实况面板
   */
  public static readonly TYPE_PHONE_LIVELIST = 5;

  /**
   * 通知类型，Tv面板
   */
  public static readonly TYPE_TV = 6;

  /**
   * 判断PC类型
   *
   * @param ntfType 通知类型
   * @return true PC
   */
  static isPc(ntfType: number): boolean {
    return ntfType === NotificationType.TYPE_PC;
  }

  /**
   * 判断Phone下拉面板类型
   *
   * @param ntfType 通知类型
   * @return true 下拉面板
   */
  static isDropdown(ntfType: number): boolean {
    return ntfType === NotificationType.TYPE_PHONE_DROPDOWN;
  }

  /**
   * 判断Phone锁屏面板类型
   *
   * @param ntfType 通知类型
   * @return true 锁屏面板
   */
  static isKeyguard(ntfType: number): boolean {
    return ntfType === NotificationType.TYPE_PHONE_KEYGUARD;
  }

  /**
   * 判断Aod锁屏面板类型
   *
   * @param ntfType 通知类型
   * @return true 锁屏面板
   */
  static isAod(ntfType: number): boolean {
    return ntfType === NotificationType.TYPE_PHONE_AOD;
  }

  /**
   * 判断Phone实况面板类型
   *
   * @param ntfType 通知类型
   * @return true Phone实况面板
   */
  static isBanner(ntfType: number): boolean {
    return ntfType === NotificationType.TYPE_PHONE_LIVELIST;
  }
}