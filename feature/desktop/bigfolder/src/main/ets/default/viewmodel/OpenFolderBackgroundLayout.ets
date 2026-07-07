/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * 文件夹展开前后背板布局参数
 */
export class OpenFolderBackgroundLayout {
  // 展开前背板宽度
  public closedWidth: number = 0;
  // 展开前背板高度
  public closedHeight: number = 0;
  // 展开后背板宽度
  public openedWidth: number = 0;
  // 展开后背板高度
  public openedHeight: number = 0;
  // 展开后背板Margin
  public openedMargin: number = 0;
  // 背板圆角（与关闭态保持一致）
  public radius: number = 0;
}