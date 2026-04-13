/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

@Observed
export class FontViewData {
  // label文字尺寸
  public fontSize: number = 0;

  // label文字行高
  public lineHeight: number = 0;

  // label文字粗细程度
  public fontWeight: FontWeight = 0;

  // hover状态下label文字尺寸
  public hoverFontSize: number = 0;

  // label长度
  public labelWidth: number = 0;

  // 是否是中文模式
  public isChineseMode: boolean = false;

  // 是否是英文模式
  public isEnglishMode: boolean = false;

  // 是否是藏文模式
  public isTibetanMode: boolean = false;

  // 是否是维语模式
  public isUyghurMode: boolean = false;

  // 是否镜像语言
  public isRTL: boolean = false;
}