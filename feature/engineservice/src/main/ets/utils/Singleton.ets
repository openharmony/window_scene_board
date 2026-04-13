/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 */
/**
 * Singleton 类，用于创建单例对象
 */
export class Singleton<T> {
  // 用于生成单例对象的生产者
  private readonly producer: () => T;
  // 存储生成的单例对象
  private mInstance: T | undefined;

  constructor(producer: () => T) {
    this.producer = producer;
  }

  /**
   * 获取单例对象
   * @return 返回单例对象
   */
  public get(): T {
    if (!this.mInstance) {
      this.mInstance = this.producer();
    }
    return this.mInstance;
  }
}