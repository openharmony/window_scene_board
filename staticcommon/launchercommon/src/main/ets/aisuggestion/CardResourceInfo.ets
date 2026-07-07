/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

/**
 * 深/浅色资源信息
 *
 * @since 2023-11-11
 */
export class CardResourceInfo {
  // 小插画资源ID
  public picResId: string = '';

  // 铺满式插画资源ID
  public pic1ResId: string = '';

  // 背景渐变起始色，左上角为起点
  public bgStartClr: string = '';

  // 背景渐变终止色，左上角为起点
  public bgEndClr: string = '';

  // 背景渐变中间色,对角线38%的位置
  public bgMidClr: string = '';

  // 背景渐变起始色，右下角为起点
  public fgStartClr: string = '';

  // 背景渐变终止色，右下角为起点
  public fgEndClr: string = '';

  // 场景提示语标题文字颜色
  public titleClr: string = '';

  // 场景提示语描述文字颜色
  public descClr: string = '';

  // 场景提示语1描述文字颜色
  public desc1Clr: string = '';

  // 场景提示语2描述文字颜色
  public desc2Clr: string = '';

  // 胶囊背景渐变起始色
  public chipBgStartClr: string = '';

  // 胶囊背景渐变终止色
  public chipBgEndClr: string = '';

  // 胶囊文字颜色
  public chipTextClr: string = '';
}